require 'json'
class FMSupplierData
  # Get the count of suppliers for all lots in the initial long list by location and services
  def long_list_supplier_count(locations, services)
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

  # Get the suppliers for a lot in the initial long list by location and services
  def long_list_suppliers_lot(locations, services, lot)
    query = "select name,service_code,region_code from(select
	distinct initcap(fms.name) as name,
	array(
	select
		distinct fmso.service_code
	from
		public.facilities_management_suppliers fms,
		public.facilities_management_regional_availabilities fmra,
		public.facilities_management_service_offerings fmso
	where
		(fmra.region_code in " + locations + ")
		and (fmso.service_code in " + services + ")
		and fms.id = fmra.facilities_management_supplier_id
		and fmso.facilities_management_supplier_id = fms.id
		and fmso.lot_number = '" + lot + "') as service_code,
	array(
	select
		distinct fmra.region_code
	from
		public.facilities_management_suppliers fms,
		public.facilities_management_regional_availabilities fmra,
		public.facilities_management_service_offerings fmso
	where
		(fmra.region_code in " + locations + ")
		and (fmso.service_code in " + services + ")
		and fms.id = fmra.facilities_management_supplier_id
		and fmso.facilities_management_supplier_id = fms.id
		and fmso.lot_number ='" + lot + "') as region_code
from
	public.facilities_management_suppliers fms,
	public.facilities_management_regional_availabilities fmra,
	public.facilities_management_service_offerings fmso
where
	(fmra.region_code in " + locations + ")
	and (fmso.service_code in " + services + " )
	and fms.id = fmra.facilities_management_supplier_id
	and fmso.facilities_management_supplier_id = fms.id
	and fmso.lot_number = '" + lot + "' order by name) sups;"
    result = ActiveRecord::Base.connection.execute(query)
    JSON.parse(result.to_json)
  end
end
