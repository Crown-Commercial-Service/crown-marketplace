module FacilitiesManagement::PageDetail::RM3830::Supplier::Dashboard
  include FacilitiesManagement::PageDetail

  def page_definitions
    @page_definitions ||= {
      default: {},
      index: {
        page_title: 'Direct award dashboard',
        caption1: current_user.email
      }
    }.freeze
  end
end
