module Pages
  def admin_page
    @admin_page ||= Pages::Admin.new
  end

  def building_page
    @building_page ||= Pages::Building.new
  end

  def contract_detail_page
    @contract_detail_page ||= Pages::ContractDetail.new
  end

  def direct_award_page
    @direct_award_page ||= Pages::DirectAward.new
  end

  def entering_requirements_page
    @entering_requirements_page ||= Pages::EnteringRequirements.new
  end

  def procurement_page
    @procurement_page ||= Pages::Procurement.new
  end

  def quick_view_results_page
    @quick_view_results_page ||= Pages::QuickViewResults.new
  end

  def service_requirement_page
    @service_requirement_page ||= Pages::ServiceRequirement.new
  end
end
