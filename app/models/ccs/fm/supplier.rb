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

      # CCS::FM::Supplier.long_list_suppliers_lot('Xuan Durgan')
      def self.long_list_suppliers_lot(locations, services, lot)
        vals = selected_suppliers(lot, locations, services)

        result =
          vals.map do |s|
            lot = s.data['lots'].select do |x|
              x['lot_number'] = lot
            end
            lot = lot&.first
            { 'name' => s.data['supplier_name'],
              'service_code' => lot['services'],
              'region_code' => lot['regions'] }
          end
        result
      end
    end
  end
end
