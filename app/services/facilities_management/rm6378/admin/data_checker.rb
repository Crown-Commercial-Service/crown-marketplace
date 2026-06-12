class FacilitiesManagement::RM6378::Admin::DataChecker < DataChecker
  def check_data
    errors = []

    [
      [:supplier_framework_lot_services, 'supplier_missing_services'],
      [:supplier_framework_lot_jurisdictions, 'supplier_missing_jurisdictions'],
    ].each do |key, error_key|
      supplier_missing_data = @supplier_data.select { |supplier| supplier[:supplier_frameworks].any? { |supplier_framework| supplier_framework[:supplier_framework_lots].any? { |supplier_framework_lot| supplier_framework_lot[key].empty? } } }

      errors << { error: error_key, details: supplier_missing_data.pluck(:name) } if supplier_missing_data.any?
    end

    errors
  end
end
