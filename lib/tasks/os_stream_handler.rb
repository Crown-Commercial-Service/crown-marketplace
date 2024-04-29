module OrdnanceSurvey
  # rubocop:disable  Metrics/AbcSize
  def self.read_file_from_s3(object_summary, fn_process, &block)
    data_summary                = {}
    data_summary[:length]       = object_summary.size
    data_summary[:md5]          = object_summary.etag
    data_summary[:updated_time] = object_summary.last_modified

    case File.extname(object_summary.key)
    when '.zip'
      unzip_url(object_summary.presigned_url(:get), data_summary) do |type, stream|
        fn_process.call(type, stream)
      end
    when '.gz'
      if object_summary.key.include? 'tar'
        untar_url(object_summary.presigned_url(:get), data_summary) do |type, stream|
          fn_process.call(type, stream)
        end
      else
        gunzip_url(object_summary.presigned_url(:get), data_summary) do |type, stream|
          fn_process.call(type, stream)
        end
      end
    when '.dat', '.csv'
      stream_url(object_summary, data_summary) do |type, stream|
        fn_process.call(type, stream)
      end
    else
      Rails.logger.info "Postcode processing ignoring: #{object_summary.key}"
    end
    block.call(data_summary)
  end
  # rubocop:enable  Metrics/AbcSize

  def self.stream_url(obj, data_summary, &)
    meta_type   = :dat
    chunk_count = -1
    chunks      = ''

    obj.get do |chunk|
      chunks << chunk
      if chunk_count == -1
        chunk_count = 0
        meta_type   = (chunk.downcase.include?('uprn') ? :csv : :dat) if chunk_count.zero?
      end
    end

    inject_data(chunks) if meta_type == :dat
    upsert_csv_data(StringIO.new(chunks)) if meta_type == :csv
  rescue StandardError => e
    data_summary[:fail] = e.message
    raise e
  end

  def self.untar_stream(url, summary, &block)
    Gem::Package::TarReader.new(Zlib::GzipReader.new(File.open(url))) do |tar|
      handle_tar_contents(tar, summary, &block)
    end
  end

  def self.gunzip_url(url, summary, &block)
    Zlib::GzipReader.open(File.open(url)) do |gz|
      handle_gzip_contents(gz, summary, &block)
    end
  end

  def self.unzip_url(url, summary, &block)
    Zip::InputStream.open(IO.popen(url)) do |io|
      handle_zip_contents(io, summary, &block)
    end
  end
end
