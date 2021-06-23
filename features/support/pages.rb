module Pages
  def admin_page
    @admin_page ||= Admin.new
  end

  def building_page
    @building_page ||= Building.new
  end

  def contract_page
    @contract_page ||= Contract.new
  end

  def contract_detail_page
    @contract_detail_page ||= ContractDetail.new
  end

  def entering_requirements_page
    @entering_requirements_page ||= EnteringRequirements.new
  end

  def home_page
    @home_page ||= Home.new
  end

  def procurement_page
    @procurement_page ||= Procurement.new
  end

  def quick_view_results_page
    @quick_view_results_page ||= QuickViewResults.new
  end

  def service_requirement_page
    @service_requirement_page ||= ServiceRequirement.new
  end

  def supplier_page
    @supplier_page ||= Supplier.new
  end
end
