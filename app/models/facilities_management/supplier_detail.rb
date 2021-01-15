module FacilitiesManagement
  class SupplierDetail < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :supplier_detail, optional: true
    # rubocop:disable Rails/HasManyOrHasOneDependent
    has_many :contracts, foreign_key: :supplier_id, inverse_of: :supplier, class_name: 'FacilitiesManagement::ProcurementSupplier'
    # rubocop:enable Rails/HasManyOrHasOneDependent

    def self.selected_suppliers(for_lot, for_regions, for_services)
      all.order(:supplier_name).select do |s|
        s.lot_data[for_lot] && (for_regions - s.lot_data[for_lot]['regions']).empty? && (for_services - s.lot_data[for_lot]['services']).empty?
      end
    end

    def self.long_list_suppliers_lot(locations, services, for_lot)
      vals = selected_suppliers(for_lot, locations, services)

      result =
        vals.map do |s|
          { 'name' => s.supplier_name,
            'service_code': s.lot_data[for_lot]['services'],
            'region_code': s.lot_data[for_lot]['regions'] }
        end
      result
    end

    def self.supplier_count(locations, services)
      vals_1a = selected_suppliers('1a', locations, services)
      vals_1b = selected_suppliers('1b', locations, services)
      vals_1c = selected_suppliers('1c', locations, services)

      (vals_1a + vals_1b + vals_1c).uniq.count
    end

    def full_organisation_address
      [address_line_1, address_line_2, address_town, address_county].reject(&:nil?).reject(&:empty?).join(', ') + " #{address_postcode}"
    end
  end
end
