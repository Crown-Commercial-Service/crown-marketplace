module FacilitiesManagement
  module RM6378
    class Service < ApplicationRecord
      self.table_name = 'facilities_management_rm6378_services'
      belongs_to :work_package, foreign_key: :work_package_code, inverse_of: :services

      def label_name
        "#{code} #{name}"
      end

      def service_specification
        ServiceSpecificationParser.new(work_package_code, code)
      end

      def self.find_lot_number(service_codes, annual_contract_value)
        lot_number = determine_lot_number(service_codes)

        "#{lot_number}#{determine_lot_code(lot_number, annual_contract_value)}"
      end

      def self.determine_lot_number(service_codes)
        service_count = where(code: service_codes).count
        hard_fm_service_count = where(code: service_codes, hard: true).count
        soft_fm_service_count = where(code: service_codes, soft: true).count

        if hard_fm_service_count == service_count && soft_fm_service_count < hard_fm_service_count
          # HARD FM
          '2'
        elsif soft_fm_service_count == service_count && hard_fm_service_count < soft_fm_service_count
          # SOFT FM
          '3'
        else
          # TOTAL FM
          '1'
        end
      end

      def self.determine_lot_code(lot_number, annual_contract_value)
        if lot_number == '3'
          case annual_contract_value
          when 0..1_000_000
            'a'
          when 1_000_000..7_000_000
            'b'
          else
            'c'
          end
        else
          case annual_contract_value
          when 0..1_500_000
            'a'
          when 1_500_000..10_000_000
            'b'
          else
            'c'
          end
        end
      end
    end
  end
end
