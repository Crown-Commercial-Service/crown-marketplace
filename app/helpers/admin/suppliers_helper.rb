module Admin::SuppliersHelper
  BASIC_SUPPLIER_INFORMATION_SUMMARY_ROWS = [
    [:name, I18n.t('shared.admin.suppliers.show.basic_supplier_information.name'), ->(supplier_framework) { supplier_framework.supplier_name }],
    [:duns_number, I18n.t('shared.admin.suppliers.show.basic_supplier_information.duns'), ->(supplier_framework) { supplier_framework.supplier.duns_number || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:sme, I18n.t('shared.admin.suppliers.show.basic_supplier_information.is_sme'), ->(supplier_framework) { supplier_framework.supplier.sme ? I18n.t('yes') : I18n.t('no') }],
    [:trading_name, I18n.t('shared.admin.suppliers.show.basic_supplier_information.trading_name'), ->(supplier_framework) { supplier_framework.supplier.trading_name }],
    [:additional_identifier, I18n.t('shared.admin.suppliers.show.basic_supplier_information.additional_identifier'), ->(supplier_framework) { supplier_framework.supplier.additional_identifier }]
  ].freeze

  SUPPLIER_CONTACT_INFORMATION_SUMMARY_ROWS = [
    [:name, I18n.t('shared.admin.suppliers.show.supplier_contact_information.contact_name'), ->(supplier_framework) { supplier_framework.contact_detail.name }],
    [:email, I18n.t('shared.admin.suppliers.show.supplier_contact_information.contact_email'), ->(supplier_framework) { supplier_framework.contact_detail.email }],
    [:telephone_number, I18n.t('shared.admin.suppliers.show.supplier_contact_information.telephone_number'), ->(supplier_framework) { supplier_framework.contact_detail.telephone_number || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:website, I18n.t('shared.admin.suppliers.show.supplier_contact_information.website'), ->(supplier_framework) { supplier_framework.contact_detail.website || I18n.t('shared.admin.suppliers.show.no_data') }],
  ].freeze

  ADDITIONAL_SUPPLIER_INFORMATION_SUMMARY_ROWS = [
    [:address, I18n.t('shared.admin.suppliers.show.additional_supplier_information.address'), ->(supplier_framework) { supplier_framework.contact_detail.address }],
    [:lot_1_prospectus_link, I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_1_prospectus_link'), ->(supplier_framework) { supplier_framework.contact_detail.lot_1_prospectus_link || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:lot_2_prospectus_link, I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_2_prospectus_link'), ->(supplier_framework) { supplier_framework.contact_detail.lot_2_prospectus_link || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:lot_3_prospectus_link, I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_3_prospectus_link'), ->(supplier_framework) { supplier_framework.contact_detail.lot_3_prospectus_link || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:lot_4a_prospectus_link, I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_4a_prospectus_link'), ->(supplier_framework) { supplier_framework.contact_detail.lot_4a_prospectus_link || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:lot_4b_prospectus_link, I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_4b_prospectus_link'), ->(supplier_framework) { supplier_framework.contact_detail.lot_4b_prospectus_link || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:lot_4c_prospectus_link, I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_4c_prospectus_link'), ->(supplier_framework) { supplier_framework.contact_detail.lot_4c_prospectus_link || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:lot_5_prospectus_link, I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_5_prospectus_link'), ->(supplier_framework) { supplier_framework.contact_detail.lot_5_prospectus_link || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:managed_service_provider_name, I18n.t('shared.admin.suppliers.show.additional_supplier_information.managed_service_provider_name'), ->(supplier_framework) { supplier_framework.contact_detail.managed_service_provider_name || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:managed_service_provider_email, I18n.t('shared.admin.suppliers.show.additional_supplier_information.managed_service_provider_email'), ->(supplier_framework) { supplier_framework.contact_detail.managed_service_provider_email || I18n.t('shared.admin.suppliers.show.no_data') }],
    [:managed_service_provider_telephone, I18n.t('shared.admin.suppliers.show.additional_supplier_information.managed_service_provider_telephone'), ->(supplier_framework) { supplier_framework.contact_detail.managed_service_provider_telephone || I18n.t('shared.admin.suppliers.show.no_data') }],
  ].freeze

  def basic_supplier_information_summary_rows
    @basic_supplier_information_summary_rows ||= collect_summary_rows(:basic_supplier_information, BASIC_SUPPLIER_INFORMATION_SUMMARY_ROWS)
  end

  def supplier_contact_information_summary_rows
    @supplier_contact_information_summary_rows ||= collect_summary_rows(:supplier_contact_information, SUPPLIER_CONTACT_INFORMATION_SUMMARY_ROWS)
  end

  def additional_supplier_information_summary_rows
    @additional_supplier_information_summary_rows ||= collect_summary_rows(:additional_supplier_information, ADDITIONAL_SUPPLIER_INFORMATION_SUMMARY_ROWS)
  end

  private

  def collect_summary_rows(section, summary_rows_list)
    allowed_attributes = section_attributes(section) || []

    summary_rows = []

    summary_rows_list.each do |attribute, key, value_func|
      next unless allowed_attributes.include?(attribute)

      summary_rows << {
        key: {
          text: key
        },
        value: {
          text: value_func.call(@supplier_framework)
        }
      }
    end

    summary_rows
  end
end
