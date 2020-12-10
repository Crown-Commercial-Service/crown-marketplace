module CCS
  module FM
    # CCS::FM::Supplier.all

    def self.table_name_prefix
      'fm_'
    end

    class Supplier < ApplicationRecord
      def self.selected_suppliers(for_lot, for_regions, for_services)
        # This sort by will deal with suppliers that don't have a supplier_name and place them at the end.
        # It only seems to come up in the specs, but it does come up for some reason

        CCS::FM::Supplier.all.sort_by { |s| [s.supplier_name ? 1 : 0, s.supplier_name] }.select do |s|
          s.lot_data[for_lot] && (for_regions - s.lot_data[for_lot]['regions']).empty? && (for_services - s.lot_data[for_lot]['services']).empty?
        end
      end

      # usage:
      # CCS::FM::Supplier.long_list_suppliers_lot(["UKM21", "UKC1"], ["C.1", "L.1"], "1a")
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

      #  (@suppliers_lot1a.map { |s| s['name'] } << @suppliers_lot1b.map { |s| s['name'] } << @suppliers_lot1c.map { |s| s['name'] }).flatten.uniq.count
      def self.supplier_count(locations, services)
        vals_1a = selected_suppliers('1a', locations, services)
        vals_1b = selected_suppliers('1b', locations, services)
        vals_1c = selected_suppliers('1c', locations, services)

        (vals_1a + vals_1b + vals_1c).uniq.count
      end
    end
  end
end
