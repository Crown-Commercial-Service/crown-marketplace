module OrdnanceSurvey
  def self.read_file(filename, fn_process, &block)
    data_summary = {}

    case File.extname(filename)
    when '.zip'
      unzip_file(filename, data_summary) do |type, stream|
        fn_process.call(type, stream)
      end
    when '.gz'
      if filename.include? 'tar'
        untar_file(filename, data_summary) do |type, stream|
          fn_process.call(type, stream)
        end
      else
        gunzip_file(filename, data_summary) do |type, stream|
          fn_process.call(type, stream)
        end
      end
    when '.dat', '.csv'
      stream_file(filename, data_summary) do |type, stream|
        fn_process.call(type, stream)
      end
    else
      Rails.logger.info "Postcode processing ignoring: #{filename}"
    end
    block.call(data_summary)
  end

  def self.stream_file(filename, data_summary, &)
    data_summary[:updated_time] = File.mtime(filename)
    data_summary[:length]       = File.size(filename)
    file_io                     = File.new(filename, 'r')
    header_line                 = file_io.readline
    (meta_type = (
    if header_line.downcase.include?('uprn')
      :csv
    else
      :dat
    end)) and file_io.rewind
    data_summary[:md5] = chunk_file_data(file_io, meta_type, &)
  rescue StandardError => e
    data_summary[:fail] = e.message
    raise e
  ensure
    file_io&.try(&:close)
  end

  def self.untar_file(filename, summary, &)
    summary[:updated_time] = File.mtime(filename)
    Gem::Package::TarReader.new(Zlib::GzipReader.open(filename)) do |tar|
      handle_tar_contents(tar, summary, &)
    end
  end

  def self.gunzip_file(filename, summary, &)
    summary[:updated_time] = File.mtime(filename)
    Zlib::GzipReader.open(filename) do |gz|
      handle_gzip_contents(gz, summary, &)
    end
  end

  def self.unzip_file(filename, summary, &)
    summary[:updated_time] = File.mtime(filename)
    Zip::InputStream.open(filename) do |io|
      handle_zip_contents(io, summary, &)
    end
  end
end
