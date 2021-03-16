module Pages
  def procurement_page
    @procurement_page ||= Pages::Procurement.new
  end

  def da_draft_page
    @da_draft_page ||= Pages::DaDraft.new
  end
end
