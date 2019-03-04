require 'json'
class FacilitiesManagement::LongListController < ApplicationController
  require_permission :facilities_management, only: :longList

  def longList

    @select_FM_locations = '/facilities-management/select-locations'
    @select_FM_services = '/facilities-management/select-services'

    @postedLocations = JSON.parse(params[:postedlocations])
    @postedServices = JSON.parse(params[:postedservices])

    # making the param string sql friendly
    locations = @postedLocations.to_s.tr('"', "'").sub('[', '(').sub(']', ')')
    services = @postedServices.to_s.tr('"', "'").sub('[', '(').sub(']', ')')

  # Get distinct record count
    query =
        "select count(*) as record_count from (
          select
            distinct fms.name
          from
            public.facilities_management_suppliers fms
          inner join public.facilities_management_regional_availabilities fmra on
            fms.id = fmra.facilities_management_supplier_id
          inner join public.facilities_management_service_offerings fmso on
            fms.id = fmso.facilities_management_supplier_id
          where
            (fmra.region_code in " + locations + ")
            and (fmso.service_code in " + services + " )
            and fmso.lot_number in ('1c','1b','c1')) sup;"

    result = ActiveRecord::Base.connection.execute(query)
    @supplierCount = result[0]['record_count']

    # get Lot 1a suppliers
    query =
        "select
          distinct INITCAP(fms.name) as name
        from
          public.facilities_management_suppliers fms
        inner join public.facilities_management_regional_availabilities fmra on
          fms.id = fmra.facilities_management_supplier_id
        inner join public.facilities_management_service_offerings fmso on
          fms.id = fmso.facilities_management_supplier_id
        where
          (fmra.region_code in " + locations + ")
          and (fmso.service_code in " + services + " )
          and fmso.lot_number = '1a'
      order by name;"

    # query the database
    result = ActiveRecord::Base.connection.execute(query)

    @Lot1a_suppliers = JSON.parse(result.to_json)

    p "Lot 1a " + @Lot1a_suppliers.count.to_s + ' suppliers found'


      #get lot 1b suppliers
    query =
        "select
          distinct INITCAP(fms.name) as name
        from
          public.facilities_management_suppliers fms
        inner join public.facilities_management_regional_availabilities fmra on
          fms.id = fmra.facilities_management_supplier_id
        inner join public.facilities_management_service_offerings fmso on
          fms.id = fmso.facilities_management_supplier_id
        where
          (fmra.region_code in " + locations + ")
          and (fmso.service_code in " + services + " )
          and fmso.lot_number = '1b'
      order by name;"

    # query the database
    result = ActiveRecord::Base.connection.execute(query)

    @Lot1b_suppliers = JSON.parse(result.to_json)

    p "Lot 1b " + @Lot1b_suppliers.count.to_s + ' suppliers found'

  # get lot 1c suppliers
    query =
        "select
          distinct INITCAP(fms.name) as name
        from
          public.facilities_management_suppliers fms
        inner join public.facilities_management_regional_availabilities fmra on
          fms.id = fmra.facilities_management_supplier_id
        inner join public.facilities_management_service_offerings fmso on
          fms.id = fmso.facilities_management_supplier_id
        where
          (fmra.region_code in " + locations + ")
          and (fmso.service_code in " + services + " )
          and fmso.lot_number = '1c'
      order by name;"

    # query the database
    result = ActiveRecord::Base.connection.execute(query)

    @Lot1c_suppliers = JSON.parse(result.to_json)

    p "Lot 1c " + @Lot1c_suppliers.count.to_s + ' suppliers found'

  end
end
