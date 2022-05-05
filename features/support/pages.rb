module Pages
  def admin_page
    @admin_page ||= Admin.new
  end

  def admin_rm3830_page
    @admin_rm3830_page ||= RM3830::Admin.new
  end

  def admin_rm6232_page
    @admin_rm6232_page ||= RM6232::Admin.new
  end

  def building_page
    @building_page ||= Building.new
  end

  def contract_page
    @contract_page ||= RM3830::Contract.new
  end

  def contract_detail_page
    @contract_detail_page ||= RM3830::ContractDetail.new
  end

  def entering_requirements_page
    @entering_requirements_page ||= RM3830::EnteringRequirements.new
  end

  def home_page
    @home_page ||= RM3830::Home.new
  end

  def procurement_page
    @procurement_page ||= RM3830::Procurement.new
  end

  def quick_view_results_page
    @quick_view_results_page ||= RM3830::QuickViewResults.new
  end

  def service_requirement_page
    @service_requirement_page ||= RM3830::ServiceRequirement.new
  end

  def supplier_page
    @supplier_page ||= RM3830::Supplier.new
  end
end
