module CCS
  module FM
    # CCS::FM::Supplier.all

    def self.table_name_prefix
      'fm_'
    end

    class Supplier < ApplicationRecord
      # usage:
      # CCS::FM::Supplier.where("data->'supplier_name' = 'Shields, Ratke and Parisian'")
      # CCS::FM::Supplier.supplier_name('Shields, Ratke and Parisian')
      def self.supplier_name(name)
        # p "data->'supplier_name' = '#{name}'"
        where("data->>'supplier_name' = '#{name}'")
      end

      # usage:
      # "contact_name"=>"Xuan Durgan"
      # CCS::FM::Supplier.contact_name('Xuan Durgan')
      # CCS::FM::Supplier.contact_name('Xuan Durgan').first.data
      def self.contact_name(name)
        where("data->>'contact_name' = '#{name}'")
      end

      def self.selected_suppliers(for_lot, for_regions, for_services)
        CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            # ([2, 6, 13, 99, 27] & [2, 6]).any?
            (for_regions - l['regions']).empty? && (for_services - l['services']).empty? if l['lot_number'] == for_lot
          end
        end
      end

      # usage:
      # CCS::FM::Supplier.long_list_suppliers_lot(["UKM21", "UKC1"], ["C.1", "L.1"], "1a")
      def self.long_list_suppliers_lot(locations, services, for_lot)
        vals = selected_suppliers(for_lot, locations, services)

        result =
          vals.map do |s|
            selected_lot = s.data['lots'].select do |x|
              x['lot_number'] = for_lot
            end
            first_selected_lot = selected_lot&.first
            { 'name' => s.data['supplier_name'],
              'service_code' => first_selected_lot['services'],
              'region_code' => first_selected_lot['regions'] }
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
