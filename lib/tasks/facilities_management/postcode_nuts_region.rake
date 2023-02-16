require 'csv'
require 'json'
# rubocop:disable Metrics/BlockLength
namespace :db do
  desc 'import postcode and nuts region data which matches postcode to a region code'
  task update_postcodes_to_nuts_now: :environment do
    DistributedLocks.distributed_lock(152) do
      insert_statement = <<~SQL.squish
        DO
        $do$
        begin
          if exists(select postcode from postcodes_nuts_regions pnr where postcode='$1' and code <> '$2') then
            update postcodes_nuts_regions
            set updated_at = now(), code = '$2'
            where postcode = '$1';
          ELSE
            insert into postcodes_nuts_regions (postcode, code, created_at, updated_at )
            values('$1', '$2', now(), now())
           on conflict(postcode) do nothing;
          end if;
        end
        $do$;
      SQL

      Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS').entries.reject { |f| File.directory? f }.sort.reverse.each do |filename|
        puts "Starting task for: #{filename}"
        path_name = Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS', filename)
        connection = ActiveRecord::Base.connection
        row_counter = 0
        CSV.foreach(path_name) do |row|
          puts "pc_uk_NUTS Importing #{row}, #{row_counter}" if row_counter.zero? || (row_counter % 10000).zero?
          connection.execute(insert_statement.gsub('$1', row[0].delete(' ')).gsub('$2', row[1]))
          row_counter += 1
        end
      end
    end
  rescue StandardError => e
    puts "pc_uk_NUTS Error: #{e.message}"
  end

  task run_postcodes_to_nuts: :environment do
    DistributedLocks.distributed_lock(152) do
      Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS').entries.reject { |f| File.directory? f }.each do |filename|
        data_file = Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS', filename)
        puts "Starting PostodesNutsRegions import for #{filename}"
        file = File.read(data_file)
        data = CSV.parse(file, converters: [->(field, _) { field.delete(' ') }])
        PostcodesNutsRegion.import! %i[postcode code], data, on_duplicate_key_ignore: true
        puts "PostcodesNutsRegions import done for #{filename}"
      end
    end
  end

  task run_postcodes_to_nuts_worker: :environment do
    Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS').entries.reject { |f| File.directory? f }.each do |filename|
      puts "Starting task for: #{filename}"
      FacilitiesManagement::PostcodesToNutsWorker.perform_async(Rails.root.join('data', 'facilities_management', 'pc_uk_NUTS', filename))
    end
  end
end
# rubocop:enable Metrics/BlockLength
