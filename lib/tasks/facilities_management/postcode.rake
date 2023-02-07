require 'optparse'
require Rails.root.join('lib', 'tasks', 'ordnance_survey')

# rubocop:disable Metrics/BlockLength
namespace :db do
  desc 'add OS postcode data to the database'
  # task :postcode, [:access_key, :secret_access_key, :bucket, :region] => :environment do |_, args|
  task webpostcode: :environment do |_, args|
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_postcode_locator_index
    OrdnanceSurvey.create_new_postcode_views
    OrdnanceSurvey.import_postcodes 'dataPostcode2files', args[:access_key], args[:secret_access_key], args[:bucket], args[:region]
  end

  task :local_postcode, [:folder] => :environment do |_, args|
    options = {}

    o = OptionParser.new do |opts|
      opts.banner = 'Usage: rake db:local_postcode [option]'
      opts.on('-f', '--folder ARG', String) { |folder| options[:folder] = folder }
    end
    nargs = o.order!(ARGV)
    o.parse!(nargs)
    options[:folder] = args[:folder] if options.empty? # support debugging

    p "Creating postcode database and local import from #{options[:folder] || Rails.root.join('data', 'local_postcodes')}"
    Rails.logger.info "Creating postcode database and local import from #{options[:folder] || Rails.root.join('data', 'local_postcodes')}"

    OrdnanceSurvey.create_postcode_table
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_postcode_locator_index
    OrdnanceSurvey.create_new_postcode_views
    OrdnanceSurvey.create_upload_log

    OrdnanceSurvey.import_postcodes_locally options[:folder] || Rails.root.join('data', 'local_postcodes')
    exit
  rescue StandardError => e
    p "Error: #{e.message}"
    Rails.logger.error("local_postcode: #{e.message}")
    exit
  end

  task update_postcode: :environment do
    p 'Updating postcode database'

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
      OrdnanceSurvey.import_postcodes 'updatePostcodeFiles', access_key, secret_key, bucket, region
    end
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
      OrdnanceSurvey.import_postcodes 'dataPostcode2files', access_key, secret_key, bucket, region
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

  desc 'add addresses for local environment'
  task sample_address_import: :environment do
    p 'Creating postcode database and import'
    OrdnanceSurvey.create_postcode_table
    p 'Creating address lookup view'
    OrdnanceSurvey.create_address_lookup_view
    OrdnanceSurvey.create_postcode_locator_index
    OrdnanceSurvey.create_new_postcode_views
    p 'Import address from local FM directory'
    OrdnanceSurvey.import_sample_addresses
  end

  if Rails.env.test?
    desc 'add static data to the database'
    task static: :sample_address_import
  end
end
# rubocop:enable Metrics/BlockLength
