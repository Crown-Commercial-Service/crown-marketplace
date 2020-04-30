require 'smarter_csv'
require 'rubygems/package'
require 'digest/md5'
# rubocop:disable Metrics/ModuleLength, Rails/Output
module OrdnanceSurvey
  require 'csv'
  require 'aws-sdk-s3'
  require 'json'
  require Rails.root.join('lib', 'tasks', 'distributed_locks')

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
        CREATE VIEW public.os_address_view_2
        AS
        SELECT
              CASE
                  WHEN NULLIF(adds.rm_organisation_name::text, ''::text) IS NULL THEN NULL::character varying
                  ELSE adds.rm_organisation_name
              END AS organisation,
              CASE
                  WHEN btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) = COALESCE(adds.building_name, adds.sub_building_name)::text THEN NULL::text
                  WHEN NULLIF(
                  CASE
                      WHEN NULLIF(adds.sub_building_name::text, ''::text) IS NULL THEN adds.building_name::text
                      ELSE
                      CASE
                          WHEN NULLIF(adds.building_name::text, ''::text) IS NULL THEN adds.sub_building_name::text
                          ELSE adds.sub_building_name::text || ', '::text
                      END || COALESCE(adds.building_name, ''::text::character varying)::text
                  END, ''::text) IS NULL THEN NULL::text
                  ELSE
                  CASE
                      WHEN NULLIF(adds.sub_building_name::text, ''::text) IS NULL THEN adds.building_name::text
                      ELSE
                      CASE
                          WHEN NULLIF(adds.building_name::text, ''::text) IS NULL THEN adds.sub_building_name::text
                          ELSE adds.sub_building_name::text || ', '::text
                      END || COALESCE(adds.building_name, ''::text::character varying)::text
                  END
              END AS building,
              CASE
                  WHEN NULLIF(adds.sao_text::text, ''::text) IS NULL THEN
                  CASE
                      WHEN NULLIF(adds.pao_text::text, ''::text) IS NULL THEN NULL::character varying
                      ELSE adds.pao_text
                  END::text
                  ELSE adds.sao_text::text ||
                  CASE
                      WHEN NULLIF(adds.pao_text::text, ''::text) IS NULL THEN ''::text
                      ELSE ', '::text || adds.pao_text::text
                  END
              END AS addressable_object,
              CASE
                  WHEN NULLIF(btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text, ''::text) IS NULL THEN ''::text
                  ELSE btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) || ' '::text
              END || adds.street_description::text AS street_address,
              CASE
                  WHEN NULLIF(adds.dependent_locality::text, ''::text) IS NULL THEN ''::text
                  ELSE adds.dependent_locality::text || ', '::text
              END ||
              CASE
                  WHEN NULLIF(adds.post_town::text, ''::text) IS NULL THEN adds.town_name
                  ELSE adds.post_town
              END::text AS postal_town,
              CASE
                  WHEN NULLIF(adds.postcode::text, ''::text) IS NULL THEN NULL::character varying
                  ELSE adds.postcode
              END AS postcode,
          adds.postcode_locator,
          NULLIF(adds.sub_building_name::text, ''::text) AS sub_building_name,
          NULLIF(adds.building_name::text, ''::text) AS building_name,
          NULLIF(adds.pao_text::text, ''::text) AS pao_name,
          NULLIF(adds.sao_text::text, ''::text) AS sao_name,
          btrim((adds.pao_start_number::text || ''::text) || adds.pao_start_suffix::text) AS house_number,
          adds.street_description,
          NULLIF(adds.dependent_locality::text, ''::text) AS village,
              CASE
                  WHEN NULLIF(adds.post_town::text, ''::text) IS NULL THEN adds.town_name
                  ELSE adds.post_town
              END AS post_town,
          replace(adds.postcode_locator::text, ' '::text, ''::text) AS formatted_postcode,
          replace(adds.postcode_locator::text, ' '::text, adds.delivery_point_suffix::text) AS building_ref
        FROM os_address adds;
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
        CREATE VIEW public.postcode_lookup
        AS
          SELECT ((((
            CASE
                WHEN addresses.organisation IS NOT NULL AND NULLIF("position"(addresses.addressable_object, addresses.organisation::text), 0) IS NULL THEN initcap(addresses.organisation::text) || ', '::text
                ELSE ''::text
            END ||
            CASE
                WHEN addresses.addressable_object IS NOT NULL THEN initcap(addresses.addressable_object) || ', '::text
                WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::text
                ELSE ''::text
            END) ||
            CASE
                WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ', '::text
                ELSE initcap(addresses.street_description::text) || ', '::text
            END) || initcap(addresses.postal_town)) || ''::text) AS summary_line,
              CASE
      			WHEN addresses.organisation IS NOT NULL THEN
      				case when addresses.addressable_object is not null then
      					initcap(addresses.organisation::text) || ', '::text || initcap(addresses.addressable_object)
      				else
      					initcap(addresses.organisation::text) || ''::text
      				end
         	        WHEN addresses.addressable_object is not null then initcap(addresses.addressable_object) || ''::text
                  ELSE
      				CASE
      					WHEN addresses.building IS NOT NULL THEN initcap(addresses.building) || ', '::text
      					ELSE ''::text
      				END ||
      				CASE
      					WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::text
      					ELSE initcap(addresses.street_description::text) || ''::text
      				END
              END AS address_line_1,
              CASE
      			WHEN addresses.addressable_object is not null or addresses.organisation IS NOT NULL then
      				CASE
      					WHEN addresses.street_address IS NOT NULL THEN initcap(addresses.street_address) || ''::text
      					ELSE initcap(addresses.street_description::text) || ''::text
      				END
      			ELSE
      				''::text
            END AS address_line_2,
            initcap(addresses.postal_town) AS address_town,
            addresses.postcode_locator AS address_postcode,
            initcap(regions.region::text) AS address_region,
            regions.region_code AS address_region_code
          FROM os_address_view_2 addresses
            LEFT outer JOIN postcode_region_view regions ON regions.postcode::text = replace(addresses.postcode_locator::text, ' '::text, ''::text);
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

  def self.postcode_file_already_loaded(key)
    p "Checking file #{key}"
    query = "select count(*) from os_address_admin_uploads where filename = '#{key}' or filename = '#{extract_metadata(key)}'"

    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query(query)
      count  = result[0]['count']
      count.positive?
    end
  rescue PG::Error => e
    puts e.message
    false
  end

  MATCH_1 = /dataPostcode_(?<meta>(?<date>\d*-\d*-\d*)_(?<seq>\d*)_(?<outcode>[\w]{1,2}))/.freeze
  MATCH_2 = /AddressBasePlus_.*?_(?<meta>(?<date>\d*-\d*-\d*)_(?<seq>\d*)(?>.csv-)(?<outcode>\w{1,2}))/.freeze
  def self.extract_metadata(filename)
    [MATCH_1, MATCH_2].each do |m|
      match_data = filename.match(m)
      next if match_data.nil?

      return "#{match_data[:date]}_#{match_data[:seq]}_#{match_data[:outcode].upcase}"
    end

    filename
  end

  def self.log_postcode_file_loaded(key, size, etag, created_at, updated_at)
    query = "
    INSERT INTO os_address_admin_uploads (filename, size, etag, created_at, updated_at) VALUES('#{key}', #{size}, '#{etag}', '#{created_at}', '#{updated_at}');"
    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query(query)
      puts result
    end
  rescue PG::Error => e
    puts e.message
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
    File.read(Rails.root.join('data', 'postcode', 'os_address_headers.csv'))
  end

  def self.file_type(filename)
    return :dat if filename.include? '.dat'

    :csv if filename.include? '.csv'
  end

  def self.untar_file(filename, &block)
    Gem::Package::TarReader.new(Zlib::GzipReader.open(filename)) do |tar|
      tar.each do |entry|
        block.call(file_type(entry.full_name), StringIO.new(entry.read)) if entry.file?
      end
    end
  end

  def self.untar_stream(bytes, &block)
    Gem::Package::TarReader.new(Zlib::GzipReader.new(IO.new(bytes))) do |tar|
      tar.each do |entry|
        block.call(file_type(entry.full_name), StringIO.new(entry.read)) if entry.file?
      end
    end
  end

  def self.unzip_stream(bytes, &block)
    Zip::File.new(IO.new(bytes)) do |zip_file|
      zip_file.each do |entry|
        block.call(file_type(entry.name), entry.get_input_stream)
      end
    end
  end

  def self.unzip_file(filename, &block)
    Zip::File.open(filename) do |zip_file|
      zip_file.each do |entry|
        block.call(file_type(entry.name), entry.get_input_stream)
      end
    end
  end

  def self.stream_file(filename, &block)
    block.call(File.open(filename, 'r'))
  end

  MAX_LINE_BUFFER = -1

  def self.chunk_file(type, stream, &block)
    lines = ''
    line_counter = 0

    if MAX_LINE_BUFFER.positive?
      until stream.eof?
        lines << stream.readline
        line_counter += 1
        next if MAX_LINE_BUFFER == line_counter

        block.call(type, lines)
        lines = ''
        line_counter = 0
      end
    else
      lines = stream.read
    end

    block.call(type, lines) if lines.present?
  end

  def self.read_file(filename, &block)
    case File.extname(filename)
    when '.zip'
      unzip_file(filename) do |type, stream|
        chunk_file(type, stream, &block)
      end
    when '.gz'
      untar_file(filename) do |type, stream|
        chunk_file(type, stream, &block)
      end
    when '.dat', '.csv'
      stream_file filename do |stream|
        chunk_file(:dat, stream, &block)
      end
    else
      Rails.logger.info "Postcode processing ignoring: #{filename}"
    end
  end

  # rubocop:disable Metrics/AbcSize
  def self.import_postcodes_locally(directory)
    if Dir.exist?(directory)
      Dir.entries(directory).reject { |f| File.directory? f }.sort.each do |filename|
        next if filename.starts_with?('.')

        next if postcode_file_already_loaded(File.basename(filename, File.extname(filename)))

        read_file("#{directory}/#{filename}") do |type, csv_lines|
          if process_csv_data(type, csv_lines)
            log_postcode_file_loaded(extract_metadata(filename), csv_lines.length,
                                     Digest::MD5.hexdigest(csv_lines),
                                     File.mtime("#{directory}/#{filename}"),
                                     DateTime.now.utc)
          end
        rescue StandardError => e
          Rails.logger.error(["POSTCODE: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR)
        end
      end
    else
      Rails.logger.info("POSTCODE: No folder for local postcode import found (#{directory})")
    end
  end
  # rubocop:enable Metrics/AbcSize

  def self.process_csv_data(type, csv_lines)
    return inject_data(csv_lines) if type == :dat

    return upsert_csv_data(csv_lines) unless type == :dat
  end

  def self.upsert_csv_data(csv)
    csv_headers = []
    csv_headers = os_address_headers.split(',') unless csv.include? os_address_headers
    fully_processed = true
    SmarterCSV.process(StringIO.new(csv), user_provided_headers: csv_headers, chunk_size: 1000, remove_blank_values: false) do |chunk|
      ActiveRecord::Base.connection_pool.with_connection do |db|
        db.begin_db_transaction
        chunk.each do |row|
          upsert_row(db, row)
        end
        db.commit_db_transaction
      rescue StandardError => e
        db.rollback_db_transaction
        Rails.logger.error(["POSTCODE: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR)
        fully_processed = false
      end
    end
    fully_processed
  rescue StandardError => e
    Rails.logger.error(["POSTCODE: #{e.message}"] + e.backtrace).join($INPUT_RECORD_SEPARATOR)
    false
  end

  INSERT_COLUMNS = %i[uprn udprn class parent_uprn last_update_date rm_organisation_name sub_building_name building_name building_number
                      sao_start_number sao_start_suffix sao_end_number sao_end_suffix sao_text
                      pao_start_number pao_start_suffix pao_end_number pao_end_suffix pao_text street_description dependent_thoroughfare
                      thoroughfare dependent_locality locality town_name administrative_area post_town postcode postcode_locator po_box_number ward_code].freeze
  INTEGER_COLUMNS = %i[uprn udprn parent_uprn sao_start_number sao_end_number pao_start_number pao_end_number].freeze

  # rubocop:disable Metrics/CyclomaticComplexity
  def self.upsert_row(db, row)
    new_date = DateTime.parse(row[:last_update_date])
    result = db.exec_query(os_address_select(row))
    db_date = result.empty? ? new_date : DateTime.parse(result[0]['last_update_date'])
    db.execute(os_address_delete(row)) if db_date < new_date || result.length > 1
    db.execute(os_address_insert(row)) if result.empty? || new_date >= db_date || result.length > 1
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

    return "'#{row[col]}'" unless INTEGER_COLUMNS.include?(col)

    row[col].to_s
  end

  def self.inject_data(lines)
    ActiveRecord::Base.connection_pool.with_connection do |conn|
      rc = conn.raw_connection
      rc.exec('COPY os_address FROM STDIN WITH CSV')
      rc.put_copy_data lines
      rc.put_copy_end
    end
    rescue StandardError => e
      Rails.logger.error e.message
  end

  # rubocop:disable CyclomaticComplexity, PerceivedComplexity, Metrics/AbcSize
  def self.import_postcodes(access_key, secret_key, bucket, region)
    awd_credentials access_key, secret_key, bucket, region

    object = Aws::S3::Resource.new(region: region)
    object.bucket(bucket).objects.each do |obj|
      next unless obj.key.starts_with? 'dataPostcode2files'

      next if %w[.sh .zip .tar .gz].select { |ext| obj.key.include? ext }.any?

      next if postcode_file_already_loaded(extract_metadata(obj.key))

      # rc.put_copy_data(obj.get.body)
      # obj.get.body.each_line { |line| rc.put_copy_data(line) }
      puts "*** Loading file #{obj.key}"
      chunks = ''
      obj.get do |chunk|
        chunks << chunk
      end
      result = false
      case File.extname(filename)
      when '.zip'
        unzip_stream(chunks) do |type, stream|
          result = process_csv_data(type, stream)
        end
      when '.gz'
        untar_stream(chunks) do |type, stream|
          result = process_csv_data(type, stream)
        end
      when '.dat', '.csv'
        result = process_csv_data(:dat, chunks)
      else
        Rails.logger.info "Postcode processing ignoring: #{filename}"
      end

      log_postcode_file_loaded(extract_metadata(obj.key), obj.data.size, obj.data.etag, obj.data.last_modified, DateTime.now.utc) if result
    rescue Aws::S3::Errors::AccessDenied => _e
      Rails.logger.warn "Access denied on #{obj.key}"
      puts "*** Access denied on #{obj.key}"
    end
  rescue PG::Error => e
    puts e.message
  end
  # rubocop:enable  CyclomaticComplexity, PerceivedComplexity, Metrics/AbcSize
end
# rubocop:enable Metrics/ModuleLength, Rails/Output
