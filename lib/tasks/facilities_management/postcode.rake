require Rails.root.join('lib', 'tasks', 'ordnance_survey')

namespace :db do
  desc 'add OS postcode data to the database'
  # task :postcode, [:access_key, :secret_access_key, :bucket, :region] => :environment do |_, args|
  task webpostcode: :environment do |_, args|
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_postcode_locator_index
    OrdnanceSurvey.create_new_postcode_views
    OrdnanceSurvey.import_postcodes args[:access_key], args[:secret_access_key], args[:bucket], args[:region]
  end

  task local_postcode: :environment do |_, args|
    p 'Creating postcode database and local import'
=begin
    OrdnanceSurvey.create_postcode_table
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_postcode_locator_index
    OrdnanceSurvey.create_new_postcode_views
    OrdnanceSurvey.create_upload_log
=end

      OrdnanceSurvey.import_postcodes_locally args.to_a[0] || Rails.root.join('data', 'local_postcodes')
  end

  task postcode: :environment do
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_postcode_locator_index
    OrdnanceSurvey.create_new_postcode_views
    OrdnanceSurvey.create_upload_log

    ENV['RAILS_MASTER_KEY_2'] = ENV['SECRET_KEY_BASE'][0..31] if ENV['SECRET_KEY_BASE']
    creds                     = ActiveSupport::EncryptedConfiguration.new(
      config_path: Rails.root.join('config', 'credentials.yml.enc'),
      key_path: 'config/master.key',
      env_key: 'RAILS_MASTER_KEY_2',
      raise_if_missing_key: false
    )

    access_key = creds.aws_postcodes[:access_key_id]
    secret_key = creds.aws_postcodes[:secret_access_key]
    bucket     = creds.aws_postcodes[:bucket]
    region     = creds.aws_postcodes[:region]

    DistributedLocks.distributed_lock(151) do
      OrdnanceSurvey.import_postcodes access_key, secret_key, bucket, region
    end
  end

  desc 'create OS postcode table'
  task pctable: :environment do
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    p 'Creating address lookup view'
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_postcode_locator_index
    OrdnanceSurvey.create_new_postcode_views
  end
end
