class FilesImporter
  IMPORT_PROCESS_ORDER = %i[check_files process_files check_processed_data publish_data].freeze

  def initialize(upload)
    @upload = upload
    @import_module = self.class.module_parent
    @upload_module = @import_module.module_parent
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
      ActiveRecord::Base.transaction do
        ChangeLog.log_upload_supplier_data!(admin_upload: @upload, supplier_data: @supplier_data)
        @upload.publish!
      end
    end
  rescue StandardError => e
    @upload.update(import_errors: [{ error: 'upload_failed', details: e.message }])
    @upload.fail!

    Rollbar.log('error', e)
  end

  def framework
    @import_module.to_s.split('::')[1]
  end

  private

  def check_files
    @errors = @import_module::FilesChecker.new(@upload).check_files
  rescue StandardError => e
    Rollbar.log('error', e)
    @errors = [{ error: 'file_check_failed', details: e.message }]
  end

  def process_files
    @supplier_data = @import_module::FilesProcessor.new(@upload).process_files
  rescue StandardError => e
    Rollbar.log('error', e)
    @errors << { error: 'file_process_failed', details: e.message }
  end

  def check_processed_data
    @errors += @import_module::DataChecker.new(@supplier_data).check_data
  end

  def publish_data
    Upload.smart_upload!(framework, @supplier_data)
  rescue StandardError => e
    Rollbar.log('error', e)
    @errors << { error: 'file_publish_failed', details: e.message }
  end
end
