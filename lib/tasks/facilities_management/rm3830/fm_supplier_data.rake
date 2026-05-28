namespace :db do
  namespace :rm3830 do
    desc 'add the Supplier data into the database'
    task fm_supplier_data: :environment do
      puts 'Loading FM Suppliers static'
      DataLoader::TestData.import_test_data_for_framework_service('RM3830')
    end
  end
end
