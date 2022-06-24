class FacilitiesManagement::FilesImporter
  IMPORT_PROCESS_ORDER = %i[check_files process_files check_processed_data publish_data].freeze

  attr_reader :upload

  def initialize(upload, import_module)
    @upload = upload
    @import_module = import_module
    @errors = []
  end

  def import_data
    IMPORT_PROCESS_ORDER.each do |import_process|
      @upload.send("#{import_process}!")
      send(import_process)
      break if @errors.any?
    end

    if @errors.any?
      @upload.update(import_errors: @errors)
      @upload.fail!
    else
      @upload.publish!
    end
  rescue StandardError => e
    @upload.update(import_errors: [{ error: 'upload_failed' }])
    @upload.fail!

    Rollbar.log('error', e)
  end

  def import_test_data
    process_files
    publish_data
  end

  def file_sources(file_name)
    self.class::FILE_SOURCES[file_name]
  end

  private

  def check_files
    @errors += @import_module::FilesImporter::FilesChecker.new(self).check_files
  rescue StandardError => e
    Rollbar.log('error', e)
    @errors << { error: 'file_check_failed' }
  end

  def process_files
    @supplier_data = @import_module::FilesImporter::FilesProcessor.new(self).process_files
  rescue StandardError => e
    Rollbar.log('error', e)
    @errors << { error: 'file_process_failed' }
  end

  def check_processed_data
    @errors += @import_module::FilesImporter::DataChecker.new(@supplier_data).check_data
  end

  def publish_data
    @import_module::FilesImporter::DataUploader.upload!(@supplier_data, **other_data)
  rescue StandardError => e
    Rollbar.log('error', e)
    @errors << { error: 'file_publish_failed' }
  end
end
