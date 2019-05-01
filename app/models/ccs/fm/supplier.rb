module CCS
  module FM
    # CCS::FM::Supplier.all

    def self.table_name_prefix
      'fm_'
    end

    class Supplier < ApplicationRecord
      # usage:
      # CCS::FM::Supplier.all.where("data->'supplier_name' = 'Shields, Ratke and Parisian'")
      # CCS::FM::Supplier.supplier_name('Shields, Ratke and Parisian')
      def self.supplier_name(name)
        # p "data->'supplier_name' = '#{name}'"
        CCS::FM::Supplier.all.where("data->>'supplier_name' = '#{name}'")
      end

      # usage:
      # "contact_name"=>"Xuan Durgan"
      # CCS::FM::Supplier.contact_name('Xuan Durgan')
      # CCS::FM::Supplier.contact_name('Xuan Durgan').first.data
      def self.contact_name(name)
        CCS::FM::Supplier.all.where("data->>'contact_name' = '#{name}'")
      end
    end
  end
end
