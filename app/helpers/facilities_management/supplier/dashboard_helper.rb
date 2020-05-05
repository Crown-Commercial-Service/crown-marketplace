module FacilitiesManagement::Supplier::DashboardHelper
  def accepted_page
    ['accepted', 'live', 'not signed', 'withdrawn']
  end

  SUPPLIER_STATUS = { declined: 'Declined', expired: 'Not responded', not_signed: 'Not signed', withdrawn: 'Withdrawn' }.freeze

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
