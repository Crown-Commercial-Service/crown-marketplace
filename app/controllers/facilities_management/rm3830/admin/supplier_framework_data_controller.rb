module FacilitiesManagement
  module RM3830
    module Admin
      class SupplierFrameworkDataController < FacilitiesManagement::Admin::FrameworkController
        def index
          @fm_suppliers = SuppliersAdmin.order(:supplier_name).select(:supplier_id, :supplier_name, :lot_data).map do |supplier|
            { name: supplier.supplier_name, lot_numbers: supplier.lot_data.keys, supplier_id: supplier.supplier_id }
          end

          @supplier_present = {
            '1a' => supplier_lot_present('1a'),
            '1b' => supplier_lot_present('1b'),
            '1c' => supplier_lot_present('1c')
          }
        end

        private

        def supplier_lot_present(lot_number)
          @fm_suppliers.map { |data| [data[:supplier_id], true] if data[:lot_numbers].include?(lot_number) }.compact.to_h
        end
      end
    end
  end
end
