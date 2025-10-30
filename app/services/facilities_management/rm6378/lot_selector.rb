module FacilitiesManagement::RM6378
  class LotSelector
    attr_reader :lot_results

    def initialize(facilities_management_lot_result, security_lot_result)
      @lot_results = [facilities_management_lot_result, security_lot_result].compact
    end

    class << self
      def select_lot_numbers(service_numbers, annual_contract_value)
        facilities_management_service_numbers = service_numbers.select { |service_code| service_code[0] < 'S' }
        security_officer_service_numbers = service_numbers.select { |service_code| service_code[0] == 'S' }
        security_service_numbers = service_numbers.select { |service_code| service_code[0] > 'S' }

        if facilities_management_service_numbers.any? && security_service_numbers.empty?
          facilities_management_service_numbers += security_officer_service_numbers
        else
          security_service_numbers = security_officer_service_numbers + security_service_numbers
        end

        new(
          get_facilities_management_lot_result(facilities_management_service_numbers, annual_contract_value),
          get_security_lot_result(security_service_numbers)
        )
      end

      private

      def get_facilities_management_lot_result(service_numbers, annual_contract_value)
        return unless service_numbers.any?

        has_cafm = service_numbers.include?('Q2')

        service_numbers -= ['Q2']

        lot_number = determine_facilities_management_lot_number(service_numbers)

        service_numbers << (lot_number == '3' ? 'Q1' : 'Q2') if has_cafm

        LotResult.new(
          "#{lot_number}#{determine_facilities_management_lot_code(lot_number, annual_contract_value)}",
          service_numbers
        )
      end

      def get_security_lot_result(service_numbers)
        return unless service_numbers.any?

        LotResult.new(
          determine_security_lot(service_numbers),
          service_numbers
        )
      end

      def determine_facilities_management_lot_number(service_numbers)
        total_service_count = Service.where(lot_id: 'RM6378.1a', number: service_numbers).count
        hard_fm_service_count = Service.where(lot_id: 'RM6378.2a', number: service_numbers).count
        soft_fm_service_count = Service.where(lot_id: 'RM6378.3a', number: service_numbers).count

        find_lot_number(
          [
            # HARD FM
            [hard_fm_service_count, [soft_fm_service_count], '2'],
            # SOFT FM
            [soft_fm_service_count, [hard_fm_service_count], '3'],
          ],
          total_service_count,
          # TOTAL FM
          '1'
        )
      end

      def determine_facilities_management_lot_code(lot_number, annual_contract_value)
        if lot_number == '1'
          case annual_contract_value
          when 0..2_000_000
            'a'
          when 2_000_000..15_000_000
            'b'
          else
            'c'
          end
        else
          case annual_contract_value
          when 0..2_000_000
            'a'
          else
            'b'
          end
        end
      end

      def determine_security_lot(service_numbers)
        total_service_count = Service.where(lot_id: 'RM6378.4a', number: service_numbers).count

        security_officer_service_count = Service.where(lot_id: 'RM6378.4b', number: service_numbers).count
        security_systems_service_count = Service.where(lot_id: 'RM6378.4c', number: service_numbers).count
        security_advisory_service_count = Service.where(lot_id: 'RM6378.4d', number: service_numbers).count

        find_lot_number(
          [
            [security_officer_service_count, [security_systems_service_count, security_advisory_service_count], '4b'],
            [security_systems_service_count, [security_officer_service_count, security_advisory_service_count], '4c'],
            [security_advisory_service_count, [security_officer_service_count, security_systems_service_count], '4d'],
          ],
          total_service_count,
          '4a'
        )
      end

      def find_lot_number(lot_groups, total_service_count, default_lot_number)
        lot_groups.each do |lot_service_count, other_lot_service_counts, lot_number|
          return lot_number if lot_service_count == total_service_count && other_lot_service_counts.all? { |other_lot_service_count| other_lot_service_count < lot_service_count }
        end

        default_lot_number
      end
    end

    class LotResult
      attr_reader :lot_id, :service_ids

      def initialize(lot_number, service_numbers)
        @lot_id = "RM6378.#{lot_number}"
        @service_ids = service_numbers.map { |service_number| "#{@lot_id}.#{service_number}" }
      end
    end
  end
end
