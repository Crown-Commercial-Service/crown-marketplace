module Pages
  def building_page
    @building_page ||= Pages::Building.new
  end

  def common_page
    @common_page ||= Pages::Common.new
  end

  def contract_detail_page
    @contract_detail_page ||= Pages::ContractDetail.new
  end

  def da_draft_page
    @da_draft_page ||= Pages::DaDraft.new
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
