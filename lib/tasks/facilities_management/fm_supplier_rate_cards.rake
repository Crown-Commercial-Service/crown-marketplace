module FM

  require 'roo'
  require 'json'

  def self.add_rate_cards_to_suppliers
    rate_cards_workbook = Roo::Spreadsheet.open 'data/facilities_management/Direct Award Rate Cards - anonymised1.xlsx'

    data = {}

    ['Prices', 'Discount', 'Variances'].each do |sheet_name|
      sheet = rate_cards_workbook.sheet(sheet_name)

      data[sheet_name] = {}

      labels = sheet.row(1)
      last_row = sheet.last_row
      (2..last_row).each do |row_number|
        row = sheet.row(row_number)

        rate_card = labels.zip(row).to_h

        p rate_card
        data[sheet_name][rate_card['Supplier']] = [] unless data[sheet_name][rate_card['Supplier']]

        data[sheet_name][rate_card['Supplier']] << rate_card

      end
    end

    p data

  end


end

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

