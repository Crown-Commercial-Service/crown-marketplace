#!/usr/bin/env ruby
require 'roo'
require 'json'
require 'securerandom'
require 'uk_postcode'
require 'geocoder'
require 'capybara'
require 'pathname'
require 'yaml'
require 'csv'
require 'aws-sdk-s3'

def generate_vendor_pricing
  object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
  accredited_suppliers_path = './storage/supply_teachers/current_data/input/current_accredited_suppliers.xlsx'
  FileUtils.touch(accredited_suppliers_path)
  object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(SupplyTeachers::Admin::Upload::CURRENT_ACCREDITED_PATH).get(response_target: accredited_suppliers_path)
  supplier_lookup_path = './storage/supply_teachers/current_data/input/supplier_lookup.csv'
  FileUtils.touch(supplier_lookup_path)
  object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(SupplyTeachers::Admin::Upload::SUPPLIER_LOOKUP_PATH).get(response_target: supplier_lookup_path )

  accredited_suppliers_workbook = Roo::Spreadsheet.open accredited_suppliers_path
  suppliers = []
  csv = CSV.open(supplier_lookup_path, headers: true)
  csv.each do |row|
    suppliers << row.to_h.transform_keys!(&:to_sym)
  end

  lot_1_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 1 - Preferred Supplier List')
  lot_1_accreditation =
    lot_1_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])

  lot_2_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 2 - Master Vendor MSP')
  lot_2_accreditation =
    lot_2_accreditation_sheet.parse(header_search: ['Supplier Name - Accreditation Held'])

  lot_3_accreditation_sheet = accredited_suppliers_workbook.sheet('Lot 3 - Neutral Vendor MSP')
  lot_3_accreditation =
    lot_3_accreditation_sheet.parse(header_search: ['Supplier Name'])

  accredited_suppliers_hashes = lot_1_accreditation + lot_2_accreditation + lot_3_accreditation
  accredited_supplier_names = accredited_suppliers_hashes.map(&:values).flatten

  @accredited_suppliers = suppliers.select do |supplier|
    accredited_supplier_names.include?(supplier[:'accreditation supplier name'])
  end
# rubocop:disable Style/PreferredHashMethods, Rails/Blank
  def supplier_accredited?(id)
    return false if id.nil? || id.empty?

    @accredited_suppliers.select { |supplier| supplier.has_value?(id) }.any?
  end
# rubocop:enable Style/PreferredHashMethods, Rails/Blank

  path = './storage/supply_teachers/current_data/input/geographical_data.xlsx'
  object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(SupplyTeachers::Admin::Upload::LOT_1_AND_LOT2_PATH).get(response_target: path)

  mv_price_workbook = Roo::Spreadsheet.open path

  def subhead?(row)
    row[:number] =~ /Category Line/ || row[:number].nil?
  end

  def add_mv_headings(row)
    %i[number supplier_name role job_type lot1_fee1 lot1_fee2 lot1_fee3 blank lot2_fee1 lot2_fee2 lot2_fee3].zip(row).to_h
  end

  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
  def symbolize_job_types(row)
    job_type = case row[:job_type]
               when /Qualified.*Non-Special/m
                 :qt
               when /Qualified.*Special/m
                 :qt_sen
               when /Unqualified.*Non-Special/m
                 :uqt
               when /Unqualified.*Special/m
                 :uqt_sen
               when /Support.*Non-Special/m
                 :support
               when /Support.*Special/m
                 :support_sen
               when /Senior/m
                 :senior
               when /Clerical/m
                 :admin
               when /Nominated/m
                 :nominated
               when /Fixed Term/m
                 :fixed_term
               else
                 File.open('./storage/supply_teachers/current_data/output/errors.out.tmp', 'a') do |f|
                   f.puts "#{row[:supplier_name]}: Unknown job type in 'lot_1_and_2_comparisons.xlsx': #{row[:job_type].inspect}" if supplier_accredited?(row[:supplier_name])
                 end
                 :unknown
               end
    row.merge(job_type: job_type)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

  def normalize_mv_pricing(row)
    case row[:job_type]
    when :nominated, :fixed_term
      row.merge(fee: row[:lot2_fee1])
    else
      [row.merge(term: :one_week, fee: row[:lot2_fee1]),
       row.merge(term: :twelve_weeks, fee: row[:lot2_fee2]),
       row.merge(term: :more_than_twelve_weeks, fee: row[:lot2_fee3])]
    end
  end

  def remove_unused_keys(row)
    row.select { |key, _value| %i[supplier_name line_no job_type term fee].include? key }
  end

  def invalid_fee?(row)
    !row[:fee].is_a?(Float)
  end

  def nest(row, key)
    supplier_name = row[:supplier_name]
    other_records = row.reject { |k, _v| k == :supplier_name }
    { :supplier_name => supplier_name, key => [other_records] }
  end

  def strip_fields(row)
    row.map { |k, v| [k, v.is_a?(String) ? v.strip : v] }.to_h
  end

  # rubocop:disable Metrics/MethodLength
  def collate(records)
    suppliers = records.map { |p| p[:supplier_name] }.uniq
    suppliers.map do |supplier|
      base_record = { supplier_name: supplier }
      supplier_records = records.select { |p| p[:supplier_name] == supplier }
      supplier_records.each do |rec|
        rec.each do |k, v|
          next if k == :supplier_name

          base_record[k] = [] unless base_record.key?(k)
          base_record[k] += v
        end
      end
      base_record
    end
  end
  # rubocop:enable Metrics/MethodLength


  mv_mark_up_sheet = mv_price_workbook.sheet('Sheet1')
  mv_pricing = mv_mark_up_sheet
                 .map            { |row| add_mv_headings(row) }
                 .map.with_index { |row, index| row.merge(line_no: index + 1) }
                 .reject         { |row| subhead?(row) }
                 .map            { |row| strip_fields(row) }
                 .map            { |row| symbolize_job_types(row) }
                 .flat_map       { |row| normalize_mv_pricing(row) }
                 .map            { |row| remove_unused_keys(row) }
                 .reject         { |row| invalid_fee?(row) }
                 .map            { |row| nest(row, :master_vendor_pricing) }

  nv_pricing = [
    {
      supplier_name: 'GRI UK',
      job_type: :nominated,
      fee: 0.04
    },
    {
      supplier_name: 'GRI UK',
      job_type: :daily_fee,
      fee: 2.50
    }
  ].map { |row| nest(row, :neutral_vendor_pricing) }

  collated = collate(mv_pricing + nv_pricing)

  File.open('./storage/supply_teachers/current_data/output/supplier_vendor_pricing.json.tmp', 'w') do |f|
    f.puts JSON.pretty_generate(collated)
  end
end
