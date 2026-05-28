namespace :db do
  namespace :rm6232 do
    desc 'Imports the suppliers into the database'
    task import_suppliers: :environment do
      DataLoader::TestData.import_test_data_for_framework_service('RM6232')
    end
  end
end
