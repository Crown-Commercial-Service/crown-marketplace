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
        suppliers = CCS::FM::Supplier.all.select do |s|
          s.data['lots'].find do |l|
            (l['lot_number'] == for_lot) &&
              (for_regions & l['regions']).any? &&
              (for_services & l['services']).any?
          end
        end
      end

    end
  end
end
