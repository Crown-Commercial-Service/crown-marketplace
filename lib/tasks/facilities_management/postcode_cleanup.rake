namespace :db do
  task postcode_cleanup: :environment do
    puts 'Dropping os_address table'
    ActiveRecord::Base.connection.execute('DROP TABLE os_address;')
    puts 'Dropping os_address_admin_uploads table'
    ActiveRecord::Base.connection.execute('DROP TABLE os_address_admin_uploads;')
    puts 'Dropping finished'
  end
end
