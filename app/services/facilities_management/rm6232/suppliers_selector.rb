module FacilitiesManagement::RM6232
  class SuppliersSelector
    attr_reader :lot_number, :selected_suppliers

    def initialize(service_codes, region_codes, annual_contract_value)
      @lot_number = Service.find_lot_number(service_codes, annual_contract_value)
      @selected_suppliers = Supplier.select_suppliers(@lot_number.last, service_codes, region_codes)
    end
  end
end
