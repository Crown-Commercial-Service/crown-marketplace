module FacilitiesManagement
  module Admin
    class SuppliersFrameworkDataController < FacilitiesManagement::Admin::FrameworkController
      def index
        @fm_suppliers = FacilitiesManagement::Admin::SuppliersAdmin.all.order(Arel.sql("data->'supplier_name'")).pluck(:data).map do |supplier|
          [supplier['supplier_name'], { lot_numbers: supplier['lots'].map { |lots| lots['lot_number'] }, supplier_id: supplier['supplier_id'] }]
        end.to_h

        @supplier_lot1a_present = supplier_lot_present('1a')
        @supplier_lot1b_present = supplier_lot_present('1b')
        @supplier_lot1c_present = supplier_lot_present('1c')
      end

      private

      def supplier_lot_present(lot_number)
        @fm_suppliers.map { |supplier_name, data| [supplier_name, true] if data[:lot_numbers].include?(lot_number) }.compact.to_h
      end
    end
  end
end
