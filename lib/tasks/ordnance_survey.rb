require 'smarter_csv'
require 'rubygems/package'
require 'digest/md5'
require 'active_support'
require 'open-uri'

# rubocop:disable Metrics/ModuleLength, Rails/Output
module OrdnanceSurvey
  require 'csv'
  require 'aws-sdk-s3'
  require 'json'
  require Rails.root.join('lib', 'tasks', 'distributed_locks')
  include ActiveSupport::NumberHelper

  def self.create_postcode_table
    str   = File.read(Rails.root + 'data/postcode/PostgreSQL_AddressBase_Plus_CreateTable.sql')
    query = str.slice str.index('CREATE TABLE')..str.length
    query.sub!('<INSERTTABLENAME>', 'os_address')
    query.sub!('CREATE TABLE', 'CREATE TABLE IF NOT EXISTS')
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = 'CREATE INDEX IF NOT EXISTS idx_postcode ON os_address USING btree (postcode);'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  end

  def self.create_address_lookup_view
    query = "create or replace view public.os_address_view as select trim(((nullif(adds.rm_organisation_name, ' ') || ' ' || adds.pao_start_number || adds.pao_start_suffix::text) || ' '::text) || adds.street_description::text) as add1,
                adds.town_name as village, adds.post_town, adds.administrative_area as county, adds.postcode, replace(adds.postcode::text, ' '::text, ''::text) as formated_postcode,
                replace(adds.postcode::text, ' '::text, adds.delivery_point_suffix::text) as building_ref
              from os_address adds where ((adds.pao_start_number || adds.pao_start_suffix::text) || adds.street_description::text) is not null
                and adds.post_town is not null order by
                adds.pao_start_number, adds.rm_organisation_name, adds.street_description;"
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  rescue PG::Error => e
    puts e.message
  end

  def self.create_postcode_locator_index
    query = <<~SQL
      CREATE INDEX IF NOT EXISTS index_os_address_on_postcode_locator
      ON public.os_address USING btree
      (postcode_locator ASC NULLS LAST);
    SQL
    puts 'creating new index on os_address'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  end

  # rubocop:disable Metrics/MethodLength
  def self.create_new_postcode_views
    query = <<~SQL
        DO $$
        BEGIN
        CREATE VIEW os_address_view_2
        (building, street_address, postal_town, postcode_locator, sub_building_name, building_name, pao_name,
         sao_name, house_number, street_description, village, post_town, formatted_postcode, building_ref, uprn,
         class)
        AS
        SELECT CASE
        WHEN NULLIF(adds.sub_building_name::TEXT, ''::TEXT) IS NULL AND
        NULLIF(adds.building_name::TEXT, ''::TEXT) IS NULL AND NULLIF(adds.pao_text::TEXT, ''::TEXT) IS NOT NULL
        THEN adds.pao_text::TEXT || ''::TEXT
        WHEN btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT) =
        COALESCE(adds.building_name, adds.sub_building_name)::TEXT THEN NULL::TEXT
        WHEN NULLIF(
                    CASE
                    WHEN NULLIF(adds.sub_building_name::TEXT, ''::TEXT) IS NULL THEN adds.building_name::TEXT
                    ELSE
                    CASE
                    WHEN NULLIF(adds.building_name::TEXT, ''::TEXT) IS NULL THEN adds.sub_building_name::TEXT
                    ELSE adds.sub_building_name::TEXT || ', '::TEXT
                    END || COALESCE(adds.building_name, ''::TEXT::CHARACTER VARYING)::TEXT
                    END, ''::TEXT) IS NULL THEN NULL::TEXT
        ELSE
        CASE
        WHEN NULLIF(adds.sub_building_name::TEXT, ''::TEXT) IS NULL THEN adds.building_name::TEXT
        ELSE
        CASE
        WHEN NULLIF(adds.building_name::TEXT, ''::TEXT) IS NULL THEN adds.sub_building_name::TEXT
        ELSE adds.sub_building_name::TEXT || ', '::TEXT
        END || COALESCE(adds.building_name, ''::TEXT::CHARACTER VARYING)::TEXT
        END
        END                                                                                  AS building
        , CASE
        WHEN NULLIF(btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT) || ' '::TEXT,
                    ''::TEXT) IS NULL THEN ''::TEXT
        ELSE btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT) || ' '::TEXT
        END || adds.street_description::TEXT                                          AS street_address
        , CASE
        WHEN NULLIF(adds.dependent_locality::TEXT, ''::TEXT) IS NULL THEN ''::TEXT
        ELSE adds.dependent_locality::TEXT || ', '::TEXT
        END ||
        CASE
        WHEN NULLIF(adds.post_town::TEXT, ''::TEXT) IS NULL THEN adds.town_name
        ELSE adds.post_town
        END::TEXT                                                                     AS postal_town
        , adds.postcode_locator
        , NULLIF(adds.sub_building_name::TEXT, ''::TEXT)                                    AS sub_building_name
        , NULLIF(adds.building_name::TEXT, ''::TEXT)                                        AS building_name
        , NULLIF(adds.pao_text::TEXT, ''::TEXT)                                             AS pao_name
        , NULLIF(adds.sao_text::TEXT, ''::TEXT)                                             AS sao_name
        , btrim((adds.pao_start_number::TEXT || ''::TEXT) || adds.pao_start_suffix::TEXT)   AS house_number
        , adds.street_description
        , NULLIF(adds.dependent_locality::TEXT, ''::TEXT)                                   AS village
        , CASE
        WHEN NULLIF(adds.post_town::TEXT, ''::TEXT) IS NULL THEN adds.town_name
        ELSE adds.post_town
        END                                                                                  AS post_town
        , replace(adds.postcode_locator::TEXT, ' '::TEXT, ''::TEXT)                         AS formatted_postcode
        , replace(adds.postcode_locator::TEXT, ' '::TEXT, adds.delivery_point_suffix::TEXT) AS building_ref
        , adds.uprn
        , adds.class
            FROM os_address adds
            WHERE (adds.class::TEXT !~~ 'O%'::TEXT OR adds.class::TEXT ~~ 'OE%'::TEXT OR adds.class::TEXT ~~ 'OH%'::TEXT OR
            adds.class::TEXT ~~ 'ON%'::TEXT OR adds.class::TEXT ~~ 'OP%'::TEXT OR adds.class::TEXT ~~ 'OS%'::TEXT)
            AND adds.class::TEXT !~~ 'U%'::TEXT
            AND adds.class::TEXT !~~ 'CH%'::TEXT
            AND adds.class::TEXT !~~ 'CZ%'::TEXT
            AND adds.class::TEXT !~~ 'P%'::TEXT
            AND adds.class::TEXT !~~ 'CU11%'::TEXT;
      EXCEPTION
          WHEN SQLSTATE '42P07' THEN
            NULL;
        END; $$
    SQL
    p 'creating os_address_view_2'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = <<~SQL
      DO $$
      BEGIN
        CREATE VIEW public.postcode_region_view
        AS
        SELECT nuts.code AS region_code,
           nuts3.name AS region,
           nuts.postcode
        FROM postcodes_nuts_regions nuts
          JOIN nuts_regions nuts3 ON nuts3.code::text = nuts.code::text;
      EXCEPTION
        WHEN SQLSTATE '42P07' THEN
          NULL;
      END; $$
    SQL
    p 'creating postcode_region_view'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
    query = <<~SQL
        DO $$
        BEGIN
        CREATE VIEW postcode_lookup
        (summary_line, address_line_1, address_line_2, address_town, address_postcode, address_region,
        address_region_code) AS
        SELECT DISTINCT ((
        CASE
        WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::TEXT
        ELSE ''::TEXT
        END ||
        CASE
        WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ', '::TEXT
        ELSE initcap(addresses.street_description::TEXT) || ', '::TEXT
        END) || initcap(addresses.postal_town)) || ''::TEXT AS summary_line
        , CASE
        WHEN addresses.building IS NOT NULL THEN initcap(addresses.building)
        WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::TEXT
        ELSE initcap(addresses.street_description::TEXT) || ''::TEXT
        END                                                                          AS address_line_1
        , CASE
        WHEN addresses.building IS NOT NULL AND addresses.street_address IS NOT NULL
        THEN initcap(addresses.street_address) || ''::TEXT
        WHEN addresses.building IS NOT NULL THEN initcap(addresses.street_description::TEXT) || ''::TEXT
        ELSE NULL::TEXT
        END                                                                          AS address_line_2
        , initcap(addresses.postal_town)                                   AS address_town
        , addresses.postcode_locator                                       AS address_postcode
        , initcap(regions.region::TEXT)                                    AS address_region
        , regions.region_code                                              AS address_region_code
        FROM os_address_view_2              addresses
        LEFT JOIN postcode_region_view regions
        ON regions.postcode::TEXT = replace(addresses.postcode_locator::TEXT, ' '::TEXT, ''::TEXT);
      EXCEPTION
          WHEN SQLSTATE '42P07' THEN
            NULL;
        END; $$
    SQL
    p 'creating postcode_lookup_view'
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  rescue PG::Error => e
    puts e.message
  end

  # rubocop:enable Metrics/MethodLength

  def self.create_upload_log
    query = "
      CREATE TABLE IF NOT EXISTS os_address_admin_uploads (
          id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
          filename character varying(255),
          size integer,
          etag character varying(255),
          fail_reason text,
          created_at timestamp without time zone NOT NULL,
          updated_at timestamp without time zone NOT NULL);"
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }

    # -- Indices -------------------------------------------------------
    query = "
CREATE UNIQUE INDEX IF NOT EXISTS os_address_admin_uploads_filename_idx ON os_address_admin_uploads USING btree (filename);"
    ActiveRecord::Base.connection_pool.with_connection { |db| db.exec_query query }
  rescue PG::Error => e
    puts e.message
  end

  def self.postcode_file_already_loaded(filename)
    query = "select count(*) from os_address_admin_uploads where fail_reason is null and (filename = '#{filename}' or filename = '#{extract_metadata(filename)}')"

    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query(query)
      count  = result[0]['count']
      p "Skipping file #{filename}" if count.positive?
      return true if count.positive?
    end
    false
  rescue PG::Error => e
    puts e.message
    false
  end

  MATCH_1 = /dataPostcode_(?<meta>(?<date>\d*-\d*-\d*)_(?<seq>\d*)_(?<outcode>[\w]{1,2}))/.freeze
  MATCH_2 = /AddressBasePlus_.*?_(?<meta>(?<date>\d*-\d*-\d*)_(?<seq>\d*)((?>.csv-)(?<outcode>\w{1,2}))?)/.freeze

  def self.extract_metadata(filename, outcode = nil)
    [MATCH_1, MATCH_2].each do |m|
      match_data = filename.match(m)
      next if match_data.nil?

      result = "#{match_data[:date]}_#{match_data[:seq]}"
      result += "_#{match_data[:outcode].upcase}" unless match_data[:outcode].nil?
      outcode << match_data[:outcode] unless match_data[:outcode].nil? || outcode.nil?

      return result
    end

    filename
  end

  def self.log_postcode_file_failed(filename, reason)
    metadata = extract_metadata(filename)
    reason = reason.sub('`', '').sub('\'', '').sub('/', '/')
    query = "INSERT INTO os_address_admin_uploads (filename, fail_reason, created_at, updated_at) VALUES('#{metadata}', '#{reason}', '#{DateTime.now.utc}', '#{DateTime.now.utc}')
    on conflict (filename)
    do update set fail_reason = EXCLUDED.fail_reason, updated_at = EXCLUDED.updated_at;"
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query(query)
    end
    true
  rescue PG::Error => e
    puts e.message
    Rails.logger.error(e.message)
    false
  end

  def self.log_postcode_file_loaded(filename, size, etag, created_at, updated_at)
    key = extract_metadata(filename)
    query = "
    INSERT INTO os_address_admin_uploads (filename, size, etag, created_at, updated_at) VALUES('#{key}', #{size}, '#{etag}', '#{created_at}', '#{updated_at}')
    on conflict (filename)
    do update set fail_reason = null, size= EXCLUDED.size, etag = EXCLUDED.etag, created_at = EXCLUDED.created_at, updated_at = EXCLUDED.updated_at;"
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query(query)
    end
    true
  rescue PG::Error => e
    puts e.message
    Rails.logger.error(e.message)
    false
  end

  def self.awd_credentials(access_key, secret_key, bucket, region)
    Aws.config[:credentials] = Aws::Credentials.new(access_key, secret_key)
    p "Importing from AWS bucket: #{bucket}, region: #{region}"

    extend_timeout
  end

  def self.extend_timeout
    Aws.config[:http_open_timeout] = 6000
    Aws.config[:http_read_timeout] = 6000
    Aws.config[:http_idle_timeout] = 6000
  end

  def self.os_address_headers
    @@os_address_headers ||= File.read(Rails.root.join('data', 'postcode', 'os_address_headers.csv'))
  end

  def self.file_type(filename)
    return :dat if filename.include? '.dat'

    :csv if filename.include? '.csv'
  end

  def self.untar_file(filename, summary, &block)
    summary[:updated_time] = File.mtime(filename)
    Gem::Package::TarReader.new(Zlib::GzipReader.open(filename)) do |tar|
      handle_tar_contents(tar, summary, &block)
    end
  end

  def self.untar_stream(url, summary, &block)
    Gem::Package::TarReader.new(Zlib::GzipReader.new(URI.open(url))) do |tar|
      handle_tar_contents(tar, summary, &block)
    end
  end

  def self.handle_tar_contents(tar, summary, &block)
    tar.each do |entry|
      next unless entry.file?

      summary[:length] = entry.size
      file_stream = StringIO.new(entry.read)
      header_line = file_stream.readline
      (meta_type = (if header_line.downcase.include?('uprn')
                      :csv
                    else
                      :dat
                    end)) and file_stream.rewind
      summary[:md5] = chunk_file_data(file_stream, meta_type, &block)
    end
  end

  def self.gunzip_file(filename, summary, &block)
    summary[:updated_time] = File.mtime(filename)
    Zlib::GzipReader.open(filename) do |gz|
      handle_gzip_contents(gz, summary, &block)
    end
  end

  def self.gunzip_url(url, summary, &block)
    Zlib::GzipReader.open(URI.open(url)) do |gz|
      handle_gzip_contents(gz, summary, &block)
    end
  end

  def self.handle_gzip_contents(gz, summary, &block)
    header_line = gz.readline
    (meta_type = (if header_line.downcase.include?('uprn')
                    :csv
                  else
                    :dat
                  end)) and gz.rewind
    summary[:md5] = chunk_file_data(gz, meta_type, &block)
    summary[:length] = gz.pos
  end

  def self.unzip_file(filename, summary, &block)
    summary[:updated_time] = File.mtime(filename)
    Zip::InputStream.open(filename) do |io|
      handle_zip_contents( io, summary, &block)
    end
  end

  def self.unzip_url(url, summary, &block)
    Zip::InputStream.open(IO.new(URI.open(url))) do |io|
      handle_zip_contents( io, summary, &block)
    end
  end

  def self.handle_zip_contents(io, summary, &block)
    while (entry = io.get_next_entry)
      next if entry.name_is_directory?

      header_line = io.readline
      (meta_type = (if header_line.downcase.include?('uprn')
                      :csv
                    else
                      :dat
                    end)) and io.rewind
      summary[:length] = entry.size
      summary[:md5] = chunk_file_data(io, meta_type, &block)
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def self.stream_url(obj, data_summary, &_block)
    meta_type = :dat
    chunk_count = -1
    chunks = ''

    obj.get do |chunk|
      chunks << chunk
      if chunk_count == -1
        chunk_count = 0
        meta_type = (chunk.downcase.include?('uprn') ? :csv : :dat) if chunk_count.zero?
      end
    end

    inject_data(chunks) if meta_type == :dat
    upsert_csv_data(StringIO.new(chunks)) if meta_type == :csv
  rescue StandardError => e
    data_summary[:fail] = e.message
    raise e
  end

  def self.stream_file(filename, data_summary, &block)
    data_summary[:updated_time] = File.mtime(filename)
    data_summary[:length] = File.size(filename)
    file_io = File.new(filename, 'r')
    header_line = file_io.readline
    (meta_type = (if header_line.downcase.include?('uprn')
                    :csv
                  else
                    :dat
                  end)) and file_io.rewind
    data_summary[:md5] = chunk_file_data(file_io, meta_type, &block)
  rescue StandardError => e
    data_summary[:fail] = e.message
    raise e
  ensure
    file_io&.try(&:close)
  end

  CHUNK_SIZE = 100000
  def self.chunk_file_data(io, meta_type, &block)
    counter = 0
    chunk = ''
    md5 = Digest::MD5.new
    io.each do |line|
      (counter = 0) and (chunk = '') if counter == CHUNK_SIZE
      chunk << line
      counter += 1
      md5 << chunk if counter == CHUNK_SIZE
      block.call(meta_type, StringIO.new(chunk)) and next if counter == CHUNK_SIZE
    end
    block.call(meta_type, StringIO.new(chunk)) unless chunk.empty?
    md5.to_s
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def self.read_file_from_s3(object_summary, fn_process, &block)
    data_summary = {}
    data_summary[:length] = object_summary.size
    data_summary[:md5] = object_summary.etag
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

  def self.process_csv_data(type, csv_stream)
    return inject_data(csv_stream.read) if type == :dat

    return upsert_csv_data(csv_stream) unless type == :dat
  end

  # rubocop:disable Metrics/AbcSize
  def self.import_postcodes_locally(directory)
    if Dir.exist?(directory)
      beginning_time = Time.current
      Dir.entries(directory).reject { |f| File.directory? f }.sort.each do |filename|
        next if filename.starts_with?('.')

        next if postcode_file_already_loaded(File.basename(filename, File.extname(filename)))

        next if File.extname(filename) == '.sh'

        p "Processing    #{filename}"
        file_time = Time.current
        read_file("#{directory}/#{filename}", method(:process_csv_data)) do |summation|
          p "Duration for #{filename}, of #{ActiveSupport::NumberHelper.number_to_human_size summation[:length]} is #{Time.current - file_time}"
          log_postcode_file_loaded(File.basename(filename, File.extname(filename)), summation[:length],
                                   summation[:md5],
                                   summation[:updated_time],
                                   DateTime.now.utc)
        end
      rescue StandardError => e
        p "Error with    #{File.basename(filename, File.extname(filename))}: #{([e.message] + e.backtrace).join($INPUT_RECORD_SEPARATOR)}"
        log_postcode_file_failed(File.basename(filename, File.extname(filename)), e.message)
        Rails.logger.error((["POSTCODE: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR))
      end
      p "Duration: #{Time.current - beginning_time}"
      Rails.logger.info("POSTCODE: Duration #{Time.current - beginning_time}")
    else
      Rails.logger.info("POSTCODE: No folder for local postcode import found (#{directory})")
      p "POSTCODE: No folder for local postcode import found (#{directory})"
    end
  end

  def self.upsert_csv_data(csv_stream)
    fully_processed = true
    csv_headers = os_address_headers.downcase.split(',')
    SmarterCSV.process(csv_stream, user_provided_headers: csv_headers, chunk_size: 1000, remove_blank_values: false) do |chunk|
      ActiveRecord::Base.connection_pool.with_connection do |db|
        db.begin_db_transaction
        chunk.each do |row|
          upsert_row(db, row)
        end
        db.commit_db_transaction
      rescue StandardError => e
        db.rollback_db_transaction
        p "\tError with upsert: #{e.message}"
        Rails.logger.error((["POSTCODE: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR))
        fully_processed = false
        raise e
      end
    end
    fully_processed
  end
  # rubocop:enable Metrics/AbcSize

  INSERT_COLUMNS  = %i[uprn udprn class parent_uprn last_update_date rm_organisation_name sub_building_name building_name building_number
                      sao_start_number sao_start_suffix sao_end_number sao_end_suffix sao_text
                      pao_start_number pao_start_suffix pao_end_number pao_end_suffix pao_text street_description dependent_thoroughfare
                      thoroughfare dependent_locality locality town_name administrative_area post_town postcode postcode_locator po_box_number ward_code].freeze
  INTEGER_COLUMNS = %i[uprn udprn parent_uprn sao_start_number sao_end_number pao_start_number pao_end_number].freeze

  # rubocop:disable Metrics/CyclomaticComplexity
  def self.upsert_row(db, row)
    new_date = DateTime.parse(row[:last_update_date])
    result   = db.exec_query(os_address_select(row))
    db_date  = result.empty? ? new_date : DateTime.parse(result[0]['last_update_date'])
    db.execute(os_address_delete(row)) if db_date < new_date || result.length > 1
    db.execute(os_address_insert(row)) if result.empty? || new_date > db_date || result.length > 1
  end

  # rubocop:enable Metrics/CyclomaticComplexity

  def self.os_address_select(row)
    "select last_update_date from os_address where postcode_locator = '#{row[:postcode_locator]}' and uprn = #{row[:uprn]} order by last_update_date desc"
  end

  def self.os_address_delete(row)
    "delete from os_address where postcode_locator = '#{row[:postcode_locator]}' and uprn = #{row[:uprn]}"
  end

  def self.os_address_insert(row)
    "insert into os_address (#{INSERT_COLUMNS.map(&:to_s).join(',')}) values (#{INSERT_COLUMNS.map { |c| db_value(row, c) }.join(',')})"
  end

  def self.db_value(row, col)
    return 'null' if row[col].nil?

    return "'#{row[col].to_s.gsub("'", "''")}'" unless INTEGER_COLUMNS.include?(col)

    row[col].to_s
  rescue StandardError => e
    p (["dbValue Error processing column [:#{col}] in #{row}: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR)
  end

  def self.inject_data(lines)
    unless lines.nil?
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        rc = conn.raw_connection
        rc.exec('COPY os_address FROM STDIN WITH CSV')
        rc.put_copy_data lines
        rc.put_copy_end
      end
    end
  rescue StandardError => e
    Rails.logger.error e.message
  end

  def self.truncate_os_addresses
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.execute('truncate table os_address;')
    end
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.execute('vacuum os_address;')
    end
  rescue StandardError => e
    p "\tError with truncate: #{e.message}"
    Rails.logger.error((["POSTCODE truncate: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR))
    raise e
  end

  # rubocop:disable CyclomaticComplexity, PerceivedComplexity, Metrics/AbcSize
  def self.import_postcodes(folder_root, access_key, secret_key, bucket, region)
    OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
    OpenURI::Buffer.const_set 'StringMax', 0

    awd_credentials access_key, secret_key, bucket, region

    object = Aws::S3::Resource.new(region: region)
    object.bucket(bucket).objects.each do |obj|
      next if obj.key == "#{folder_root}/" || !obj.key.starts_with?(folder_root)

      next if %w[.sh].select { |ext| obj.key.include? ext }.any?

      next if postcode_file_already_loaded(extract_metadata(File.basename(obj.key, File.extname(obj.key))))

      p "Processing    #{obj.key}"

      file_time = Time.current
      read_file_from_s3(obj, method(:process_csv_data)) do |summation|
        p "Duration for #{obj.key}, of #{ActiveSupport::NumberHelper.number_to_human_size(summation[:length])} is #{Time.current - file_time}"
        log_postcode_file_loaded(obj.key, summation[:length],
                                 summation[:md5],
                                 summation[:updated_time],
                                 DateTime.now.utc)
      end
    rescue Aws::S3::Errors::AccessDenied => _e
      Rails.logger.warn "Access denied on #{obj.key}"
      puts "*** Access denied on #{obj.key}"
    rescue StandardError => e
      p "\tError: #{e.message}"
      Rails.logger.error((["POSTCODE: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR))
      raise e
    end
  rescue PG::Error => e
    puts e.message
  end
  # rubocop:enable  CyclomaticComplexity, PerceivedComplexity, Metrics/AbcSize
end
# rubocop:enable Metrics/ModuleLength, Rails/Output
