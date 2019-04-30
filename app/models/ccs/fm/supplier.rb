module CCS
  module FM
    # CCS::FM::Supplier.all

    def self.table_name_prefix
      'fm_'
    end

    class Supplier < ApplicationRecord

      # CCS::FM::Supplier.all.where("data->'supplier_name' = 'Shields, Ratke and Parisian'")
      # CCS::FM::Supplier.supplier_name('Shields, Ratke and Parisian')
      def self.supplier_name(name)
        # p "data->'supplier_name' = '#{name}'"
        CCS::FM::Supplier.all.where("data->>'supplier_name' = '#{name}'")
      end

      # "contact_name"=>"Xuan Durgan"
      # CCS::FM::Supplier.contact_name('Xuan Durgan')
      # CCS::FM::Supplier.contact_name('Xuan Durgan').first.data
      def self.contact_name(name)
        p "data->'contact_name' = '#{name}'"
        CCS::FM::Supplier.all.where("data->>'contact_name' = '#{name}'")
      end

    end
  end
end

=begin
  # Get the suppliers for a lot in the initial long list by location and services
  def long_list_suppliers_lot(locations, services, lot)
    query = "SELECT distinct data->>'supplier_name' as \"name\", lots->>'services' as  \"service_code\", lots->>'regions' as \"region_code\"
		from fm_suppliers, jsonb_array_elements(fm_suppliers.data -> 'lots') lots,
			jsonb_array_elements(lots -> 'regions') regions,
			jsonb_array_elements(lots->'services') services
		where"
    query += ' regions in ' + locations + ' and services in ' + services + " and  lots -> 'lot_number\' in ( '\"" + lot + '"\' )' \
             ' group by name, service_code, region_code' \
             " order by data->>'supplier_name'"

    rs = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
    JSON.parse(rs.to_json)
  end
=end