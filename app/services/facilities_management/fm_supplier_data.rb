require 'json'
class FMSupplierData
  # Get the count of suppliers for all lots in the initial long list by location and services
  def long_list_supplier_count(locations, services)
    query = "SELECT count(distinct(supplier_id))
					from fm_suppliers, jsonb_array_elements(fm_suppliers.data -> 'lots') lots,
						jsonb_array_elements(lots -> 'regions') regions,
						jsonb_array_elements(lots->'services') services
					where"
    query += ' regions in ' + locations + ' and services in ' + services +
             ' and  lots -> \'lot_number\' in ( \'"1a"\' , \'"1b"\', \'"1c"\')'

    rs = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
    rs[0]['count']
  end

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
end
