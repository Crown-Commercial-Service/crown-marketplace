module FacilitiesManagement
  module Beta
    module Admin
      class SublotRegionsController < FacilitiesManagement::Beta::FrameworkController
        def sublot_region_one_a
          # Get nuts regions
          h = {}
          Nuts1Region.all.each { |x| h[x.code] = x.name }
          @regions = h
          h = {}
          FacilitiesManagement::Region.all.each { |x| h[x.code] = x.name }
          @supplier = FacilitiesManagement::Admin::SuppliersAdmin.find(params['id'])
          @supplier_lot_a = @supplier.data['lots'].select { |lot| lot['lot_number'] == '1a' }
          @selected_supplier_regions = FacilitiesManagement::Beta::Supplier::SupplierRegionsHelper.supllier_selected_regions_1a(@supplier_lot_a)
          @subregions = h
        end
      end
    end
  end
end
