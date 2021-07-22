module Buildings
  def self.populate_building_table(file_name)
    file_path = "data/facilities_management/#{file_name}.csv"

    ActiveRecord::Base.connection_pool.with_connection do |db|
      truncate_query = "truncate table facilities_management_#{file_name};"
      db.query truncate_query
      CSV.read(file_path, headers: true).each do |row|
        column_names = row.headers.map { |i| "\"#{i}\"" }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        query = "INSERT INTO facilities_management_#{file_name} (#{column_names}) values (#{values})"
        db.query query
      end
    end
  rescue PG::Error => e
    puts e.message
  end
end

namespace :db do
  namespace :rm3830 do
    desc 'add building Security Types to the database'
    task buildings: :environment do
      DistributedLocks.distributed_lock(153) do
        p 'Loading security types static data'
        Buildings.populate_building_table 'security_types'
        p 'Loading building types static data'
        Buildings.populate_building_table 'building_types'
      end
    end
  end

  desc 'add building Security Types to the database'
  task static: :'rm3830:buildings' do
  end
end
