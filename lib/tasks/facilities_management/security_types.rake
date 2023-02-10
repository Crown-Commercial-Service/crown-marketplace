module SecurityTypes
  def self.populate_security_types
    file_name = 'data/facilities_management/security_types.csv'

    ActiveRecord::Base.connection_pool.with_connection do |db|
      truncate_query = 'truncate table facilities_management_security_types;'
      db.query truncate_query
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| "\"#{i}\"" }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        query = "INSERT INTO facilities_management_security_types (#{column_names}) values (#{values})"
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
    task security_types: :environment do
      DistributedLocks.distributed_lock(153) do
        p 'Loading security types static data'
        SecurityTypes.populate_security_types
      end
    end
  end

  desc 'add building Security Types to the database'
  task static: :'rm3830:security_types'
end
