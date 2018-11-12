module FacilitiesManagement::SuppliersHelper
  def contract_value_range_text(lot_number)
    FacilitiesManagement::Lot.find_by(number: lot_number).description
  end

  def grouped_by_mandatory(services)
    services.group_by(&:mandatory?).sort_by { |m, _| [true, false].index(m) }
  end

  def service_type(mandatory)
    mandatory ? 'Basic services' : 'Extra services'
  end
end
