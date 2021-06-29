module FacilitiesManagement::Supplier::DashboardHelper
  def accepted_page
    ['accepted', 'live', 'not signed', 'withdrawn']
  end

  SUPPLIER_STATUS = { declined: 'Declined', expired: 'Not responded', not_signed: 'Not signed', withdrawn: 'Withdrawn' }.freeze
end
