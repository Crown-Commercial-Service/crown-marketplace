require 'json'
class FacilitiesManagement::LongListController < ApplicationController
  require_permission :facilities_management, only: :long_list

  def long_list
    @select_fm_locations = '/facilities-management/select-locations'
    @select_fm_services = '/facilities-management/select-services'
    @posted_locations = JSON.parse(params[:postedlocations])
    @posted_services = JSON.parse(params[:postedservices])

    # making the param string sql friendly
    locations = @posted_locations.to_s.tr('"', "'").sub('[', '(').sub(']', ')')
    services = @posted_services.to_s.tr('"', "'").sub('[', '(').sub(']', ')')

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
    @supplier_count = result[0]['record_count']

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
    @suppliers_lot1a = JSON.parse(result.to_json)

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
    @suppliers_lot1b = JSON.parse(result.to_json)

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
