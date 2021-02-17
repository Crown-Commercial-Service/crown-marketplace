module Pages
  def building_page
    @building_page ||= Pages::Building.new
  end

  def common_page
    @common_page ||= Pages::Common.new
  end

  def da_draft_page
    @da_draft_page ||= Pages::DaDraft.new
  end

  def procurement_page
    @procurement_page ||= Pages::Procurement.new
  end

  def service_requirement_page
    @service_requirement_page ||= Pages::ServiceRequirement.new
  end
end
