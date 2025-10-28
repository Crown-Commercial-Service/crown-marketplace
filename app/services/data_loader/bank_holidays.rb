module DataLoader::BankHolidays
  class << self
    BANK_HOLIDAYS_CSV_PATH = Rails.root.join('data', 'bank_holidays.csv')
    BANK_HOLIDAYS_API_URL = 'https://www.gov.uk/bank-holidays.json'.freeze

    def add_bank_holidays_from_csv
      BankHoliday.transaction do
        ActiveRecord::Base.connection.truncate_tables(:bank_holidays)

        rows_from_csv.each do |row|
          BankHoliday.create!(**row)
        end
      end
    end

    def add_bank_holidays_from_csv_data_and_api
      BankHoliday.transaction do
        ActiveRecord::Base.connection.truncate_tables(:bank_holidays)

        rows_from_csv_data_and_api.each do |row|
          BankHoliday.create!(**row)
        end
      end
    end

    def update_bank_holidays_csv
      bank_holiday_rows = rows_from_csv_data_and_api

      CSV.open(BANK_HOLIDAYS_CSV_PATH, 'w') do |csv_file|
        csv_file << bank_holiday_rows[0].keys

        bank_holiday_rows.each do |row|
          csv_file << row.values
        end
      end
    end

    def bank_holiday_row_transformed(bank_holiday)
      bank_holiday['date'] = Date.new(*bank_holiday['date'].split('-').map(&:to_i)) if bank_holiday['date'].is_a? String
      bank_holiday['bunting'] = bank_holiday['bunting'].to_s == 'true'

      bank_holiday
    end

    def rows_from_csv
      CSV.read(BANK_HOLIDAYS_CSV_PATH, headers: true).map do |row|
        bank_holiday_row_transformed(row).to_h
      end
    end

    def rows_from_data
      BankHoliday.all.map do |bank_holiday|
        bank_holiday_row_transformed(bank_holiday.attributes.except('id', 'created_at', 'updated_at'))
      end
    end

    def rows_from_api
      JSON.parse(Net::HTTP.get(URI(BANK_HOLIDAYS_API_URL)))['england-and-wales']['events'].map do |row|
        bank_holiday_row_transformed(row).to_h
      end
    end

    def rows_from_csv_data_and_api
      Set.new(rows_from_data).merge(rows_from_csv).merge(rows_from_api).to_a.sort_by { |row| row['date'] }
    end
  end
end
