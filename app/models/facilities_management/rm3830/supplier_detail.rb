module FacilitiesManagement
  module RM3830
    class SupplierDetail < ApplicationRecord
      belongs_to :user, inverse_of: :supplier_detail, optional: true
      # rubocop:disable Rails/HasManyOrHasOneDependent
      has_many :contracts, foreign_key: :supplier_id, inverse_of: :supplier, class_name: 'FacilitiesManagement::RM3830::ProcurementSupplier'
      # rubocop:enable Rails/HasManyOrHasOneDependent

      def self.selected_suppliers(for_lot, for_regions, for_services)
        all.order(:supplier_name).select do |s|
          s.lot_data[for_lot] && (for_regions - s.lot_data[for_lot]['regions']).empty? && (for_services - s.lot_data[for_lot]['services']).empty?
        end
      end

      def self.long_list_suppliers_lot(locations, services, for_lot)
        vals = selected_suppliers(for_lot, locations, services)

        vals.map do |s|
          { 'name' => s.supplier_name,
            service_code: s.lot_data[for_lot]['services'],
            region_code: s.lot_data[for_lot]['regions'] }
        end
      end

      def self.supplier_count(locations, services)
        vals_1a = selected_suppliers('1a', locations, services)
        vals_1b = selected_suppliers('1b', locations, services)
        vals_1c = selected_suppliers('1c', locations, services)

        (vals_1a + vals_1b + vals_1c).uniq.count
      end

      def self.suppliers_offering_lot(for_lot)
        where("(lot_data->'#{for_lot}') is not null").order(:supplier_name).pluck(:supplier_name)
      end

      def full_organisation_address
        [address_line_1, address_line_2, address_town, address_county].compact.reject(&:empty?).join(', ') + " #{address_postcode}"
      end
    end
  end
end
