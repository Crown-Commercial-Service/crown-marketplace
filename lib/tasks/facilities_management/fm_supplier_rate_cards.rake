module FM
  require 'roo'
  require 'json'

  def self.create_fm_rate_cards_table
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query =
        'CREATE TABLE IF NOT EXISTS fm_rate_cards ( id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
          data jsonb, source_file text NOT NULL,
                                     created_at timestamp without time zone NOT NULL,
                                     updated_at timestamp without time zone NOT NULL);
         CREATE UNIQUE INDEX IF NOT EXISTS fm_rate_cards_pkey ON fm_rate_cards(id uuid_ops);
         CREATE INDEX IF NOT EXISTS idx_fm_rate_cards_gin ON fm_rate_cards USING GIN (data jsonb_ops);
         CREATE INDEX IF NOT EXISTS idx_fm_rate_cards_ginp ON fm_rate_cards USING GIN (data jsonb_path_ops);'

      db.query query
    end
  end

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/AbcSize
  def self.add_rate_cards_to_suppliers
    create_fm_rate_cards_table

    db_host = ENV['CCS_DEFAULT_DB_HOST']
    if Rails.env.development || (%w[dev. cmpdefault.db.internal.fm-preview preview sandbox].any? { |env| db_host.include?(env) })
      puts 'dummy supplier rate cards'
      spreadsheet_path = Rails.root.join('data', 'facilities_management', 'RM3830 Direct Award Data (for Dev & Test).xlsx')
    elsif ENV['SECRET_KEY_BASE']
      puts 'real supplier rate cards'
      s3_resource = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      object = s3_resource.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(ENV['DIRECT_AWARD_DATA_KEY'])
      object.get(response_target: 'data/facilities_management/DA_data.xlsx')
      spreadsheet_path = 'data/facilities_management/DA_data.xlsx'
    end

    rate_cards_workbook = Roo::Spreadsheet.open(spreadsheet_path, extension: :xlsx)
    spreadsheet_name = spreadsheet_path.to_s.split('/').last
    data = {}

    ['Prices', 'Discounts', 'Variances'].each do |sheet_name|
      sheet = rate_cards_workbook.sheet(sheet_name)

      data[sheet_name] = {}

      labels = sheet.row(1)
      last_row = sheet.last_row
      (2..last_row).each do |row_number|
        row = sheet.row(row_number)

        rate_card = labels.zip(row).to_h

        # p rate_card
        data[sheet_name][rate_card['Supplier']] = {} unless data[sheet_name][rate_card['Supplier']]

        if sheet_name == 'Prices'
          data[sheet_name][rate_card['Supplier']][rate_card['Service Ref']] = rate_card if rate_card['Service Ref']
        elsif sheet_name == 'Discounts'
          data[sheet_name][rate_card['Supplier']][rate_card['Service Ref']] = rate_card if rate_card['Service Ref']
        elsif sheet_name == 'Variances'
          data[sheet_name][rate_card['Supplier']] = rate_card
        end
      end

      File.delete(spreadsheet_path) if File.exist?(spreadsheet_path) && Rails.env.production?
    end

    # CCS::FM::RateCard.all
    v = CCS::FM::RateCard.create(data: data, source_file: spreadsheet_name)

    # all_data.save
    p "FM rate cards spreadsheet #{spreadsheet_name} (#{v.data.count} sheets) imported into database"
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity

namespace :db do
  desc 'uploading supplier rates cards'
  task fmcards: :environment do
    p '**** Loading FM Supplier rates cards'
    DistributedLocks.distributed_lock(154) do
      FM.add_rate_cards_to_suppliers
    end
  end

  desc 'add static data to the database'
  task static: :fmcards do
  end
end
