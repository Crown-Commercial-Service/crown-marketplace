module FacilitiesManagement
  module Admin
    class SuppliersFrameworkDataController < FacilitiesManagement::FrameworkController
      def index
        @fm_suppliers = FacilitiesManagement::Admin::SuppliersAdmin.all.sort_by { |k| k.data['supplier_name'] }
        @supplier_lot1a_present = {}
        @supplier_lot1b_present = {}
        @supplier_lot1c_present = {}
        @fm_suppliers.each do |suppliers|
          name = suppliers.data['supplier_name']
          supplier_data = FacilitiesManagement::Admin::SuppliersAdmin.find(suppliers.data['supplier_id'])['data']
          @supplier_lot1a_present[name] = supplier_data['lots'].select { |data| data['lot_number'] == '1a' }.present?
          @supplier_lot1b_present[name] = supplier_data['lots'].select { |data| data['lot_number'] == '1b' }.present?
          @supplier_lot1c_present[name] = supplier_data['lots'].select { |data| data['lot_number'] == '1c' }.present?
        end
      end
    end
  end
end
