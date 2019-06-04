#!/usr/bin/env ruby
require 'roo'
require 'json'
require 'securerandom'
require 'uk_postcode'
require 'geocoder'
require 'capybara'
require 'pathname'
require 'yaml'
require 'aws-sdk-s3'
require './lib/tasks/supply_teachers/scripts/helpers/accredited_suppliers.rb'

def generate_pricing
  object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
  path = './storage/supply_teachers/current_data/input/pricing.xlsx'
  FileUtils.touch(path)
  object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object(SupplyTeachers::Admin::Upload::PRICING_TOOL_PATH).get(response_target: path)
  price_workbook = Roo::Spreadsheet.open path

  def subhead?(row)
    row[:number] =~ /Category Line/ || row[:number].nil?
  end

  def add_headings(row)
    %i[number supplier_name role job_type fee1 fee2 fee3].zip(row).to_h
  end

# rubocop:disable Metrics/CyclomaticComplexity
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
                 File.open('./storage/supply_teachers/output/errors.out', 'a') do |f|
                   f.puts "#{row[:supplier_name]}: Unknown job type in 'pricing_for_tool.xlsx': #{row[:job_type].inspect}" if supplier_accredited?(row[:supplier_name])
                 end
                 :unknown
               end
    row.merge(job_type: job_type)
  end
# rubocop:enable Metrics/CyclomaticComplexity

  def normalize_pricing(row)
    case row[:job_type]
    when :nominated, :fixed_term
      row.merge(fee: row[:fee1])
    else
      [row.merge(term: :one_week, fee: row[:fee1]),
       row.merge(term: :twelve_weeks, fee: row[:fee2]),
       row.merge(term: :more_than_twelve_weeks, fee: row[:fee3])]
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

  mark_up_sheet = price_workbook.sheet('Lot 1 Pricing')
  pricing = mark_up_sheet
              .map            { |row| add_headings(row) }
              .map.with_index { |row, index| row.merge(line_no: index + 1) }
              .reject         { |row| subhead?(row) }
              .map            { |row| strip_fields(row) }
              .map            { |row| symbolize_job_types(row) }
              .flat_map       { |row| normalize_pricing(row) }
              .map            { |row| remove_unused_keys(row) }
              .reject         { |row| invalid_fee?(row) }
              .map            { |row| nest(row, :pricing) }

  collated = collate(pricing)

  File.open('./storage/supply_teachers/current_data/output/supplier_pricing.json.tmp', 'w') do |f|
    f.puts JSON.pretty_generate(collated)
  end
end