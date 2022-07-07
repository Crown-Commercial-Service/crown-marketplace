require_relative '../admin'

module Pages::RM3830
  class Admin < Pages::Admin
    section :supplier_detail_form, 'form' do
      element :'User email', '#facilities_management_rm3830_admin_suppliers_admin_user_email'
      element :'Supplier name', '#facilities_management_rm3830_admin_suppliers_admin_supplier_name'
      element :'Contact name', '#facilities_management_rm3830_admin_suppliers_admin_contact_name'
      element :'Contact email', '#facilities_management_rm3830_admin_suppliers_admin_contact_email'
      element :'Contact telephone number', '#facilities_management_rm3830_admin_suppliers_admin_contact_phone'
      element :'DUNS number', '#facilities_management_rm3830_admin_suppliers_admin_duns'
      element :'Company registration number', '#facilities_management_rm3830_admin_suppliers_admin_registration_number'
    end
  end
end
