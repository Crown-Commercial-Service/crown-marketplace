module CCS
  module FM
    # CCS::FM::Supplier.all

    def self.table_name_prefix
      'fm_'
    end

    class Supplier < ApplicationRecord
      # has_many :regional_availabilities,
      #         foreign_key: :facilities_management_supplier_id,
      #         inverse_of: :supplier,
      #         dependent: :destroy

      # has_many :service_offerings,
      #         foreign_key: :facilities_management_supplier_id,
      #         inverse_of: :supplier,
      #         dependent: :destroy

      # validates :name, presence: true

      def self.available_in_lot(lot_number)
        joins(:regional_availabilities)
          .merge(RegionalAvailability.for_lot(lot_number))
          .includes(:service_offerings)
          .uniq
      end

      def self.delete_all_with_dependents
        RegionalAvailability.delete_all
        ServiceOffering.delete_all
        delete_all
      end

      def self.available_in_lot_and_regions(lot_number, region_codes)
        where(id: RegionalAvailability
                    .supplier_ids_for_lot_and_regions(lot_number, region_codes))
          .joins(:regional_availabilities)
          .merge(RegionalAvailability
                  .for_lot_and_regions(lot_number, region_codes))
          .includes(:service_offerings)
          .uniq
      end

      def services_by_work_package_in_lot(lot_number)
        service_offerings_in_lot(lot_number).map(&:service).group_by(&:work_package)
      end

      def service_offerings_in_lot(lot_number)
        service_offerings.select { |so| so.lot_number == lot_number }
      end
    end
  end
end
