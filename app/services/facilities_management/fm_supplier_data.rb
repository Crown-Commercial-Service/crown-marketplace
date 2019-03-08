require 'json'
class FMSupplierData
  def long_list_supplier_count(locations, services)
    # Get the count of suppliers for all lots in the initial long list
    query = "select count(*) as record_count from (
          select
            distinct fms.name
          from
            public.facilities_management_suppliers fms,
	          public.facilities_management_regional_availabilities fmra,
	          public.facilities_management_service_offerings fmso
          where
            (fmra.region_code in " + locations + ")
            and fms.id = fmra.facilities_management_supplier_id
            and fmso.facilities_management_supplier_id = fms.id
            and (fmso.service_code in " + services + " )
            and fmso.lot_number in ('1c','1b','c1')) sup;"
    result = ActiveRecord::Base.connection.execute(query)
    result[0]['record_count']
  end
  def long_list_suppliers_lot1a(locations, services)
    # Get the suppliers for lot1a in the initial long list
    query = "select
          distinct INITCAP(fms.name) as name
        from
          public.facilities_management_suppliers fms,
	        public.facilities_management_regional_availabilities fmra,
	        public.facilities_management_service_offerings fmso
        where
          (fmra.region_code in " + locations + ")
          and (fmso.service_code in " + services + " )
          and fms.id = fmra.facilities_management_supplier_id
          and fmso.facilities_management_supplier_id = fms.id
          and fmso.lot_number = '1a'
      order by name;"
    result = ActiveRecord::Base.connection.execute(query)
    JSON.parse(result.to_json)
  end
  def long_list_suppliers_lot1b(locations, services)
    # Get the suppliers for lot1b in the initial long list
    query = "select
          distinct INITCAP(fms.name) as name
        from
          public.facilities_management_suppliers fms,
	        public.facilities_management_regional_availabilities fmra,
	        public.facilities_management_service_offerings fmso
        where
          (fmra.region_code in " + locations + ")
          and (fmso.service_code in " + services + " )
          and fms.id = fmra.facilities_management_supplier_id
          and fmso.facilities_management_supplier_id = fms.id
          and fmso.lot_number = '1b'
      order by name;"
    result = ActiveRecord::Base.connection.execute(query)
    JSON.parse(result.to_json)
  end
  def long_list_suppliers_lot1c(locations, services)
    # Get the suppliers for lot1c in the initial long list
    query = "select
          distinct INITCAP(fms.name) as name
        from
          public.facilities_management_suppliers fms,
	        public.facilities_management_regional_availabilities fmra,
	        public.facilities_management_service_offerings fmso
        where
          (fmra.region_code in " + locations + ")
          and (fmso.service_code in " + services + " )
          and fms.id = fmra.facilities_management_supplier_id
          and fmso.facilities_management_supplier_id = fms.id
          and fmso.lot_number = '1c'
      order by name;"
    result = ActiveRecord::Base.connection.execute(query)
    @suppliers_lot1c = JSON.parse(result.to_json)
  end
end
