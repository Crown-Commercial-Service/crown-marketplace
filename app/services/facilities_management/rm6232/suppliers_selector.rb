module FacilitiesManagement::RM6232
  class SuppliersSelector
    attr_reader :lot_number, :selected_suppliers

    def initialize(service_codes, region_codes, sector_code, contract_cost)
      @lot_number = Service.find_lot_number(service_codes, contract_cost)
      @selected_suppliers = Supplier.select_suppliers(@lot_number, service_codes, region_codes, sector_code)
    end
  end
end
