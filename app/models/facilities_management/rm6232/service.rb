module FacilitiesManagement
  module RM6232
    class Service < ApplicationRecord
      belongs_to :work_package, foreign_key: :work_package_code, inverse_of: :services

      def available_lots
        lots = []
        lots << 'total' if total
        lots << 'hard' if hard
        lots << 'soft' if soft
        lots
      end

      def hyphenate_code
        code.gsub('.', '-')
      end

      def self.find_lot_number(service_codes, contract_cost)
        lot_number = determine_lot_number(service_codes)

        "#{lot_number}#{determine_lot_code(lot_number, contract_cost)}"
      end

      def self.determine_lot_number(service_codes)
        hard_fm_service_count = where(code: service_codes, hard: true).count
        soft_fm_service_count = where(code: service_codes, soft: true).count
        service_count = where(code: service_codes).count

        if hard_fm_service_count == service_count && soft_fm_service_count < hard_fm_service_count
          # HARD FM
          '2'
        elsif soft_fm_service_count == service_count && hard_fm_service_count < service_count
          # SOFT FM
          '3'
        else
          # TOTAL FM
          '1'
        end
      end

      def self.determine_lot_code(lot_number, contract_cost)
        if lot_number == '1'
          case contract_cost
          when 0..1000000
            'a'
          when 0..7000000
            'b'
          when 7000000..50000000
            'c'
          else
            'd'
          end
        else
          case contract_cost
          when 0..7000000
            'a'
          when 7000000..50000000
            'b'
          else
            'c'
          end
        end
      end
    end
  end
end
