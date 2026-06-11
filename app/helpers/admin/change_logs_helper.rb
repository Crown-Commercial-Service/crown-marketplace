# rubocop:disable Metrics/ModuleLength
module Admin::ChangeLogsHelper
  # rubocop:disable Metrics/AbcSize
  def additional_change_log_summary
    summary_list_items = []

    unless exclude_section_from_summary?(@change_log.change_type, :upload_supplier_data)
      summary_list_items << build_summary_item(
        t('shared.admin.change_logs.show.summary_list.supplier_name'),
        @change_log.change_data['supplier_name']
      )
    end

    if include_section_in_summary?(@change_log.change_type, *%i[update_supplier_framework_lot_status update_supplier_framework_lot_services update_supplier_framework_lot_rates update_supplier_framework_lot_jurisdictions update_supplier_framework_lot_branch add_rates_for_supplier_framework_lot_jurisdiction remove_rates_for_supplier_framework_lot_jurisdiction])
      lot = Lot.find(@change_log.change_data['lot_id'])

      summary_list_items << build_summary_item(
        t('shared.admin.change_logs.show.summary_list.lot'),
        t('shared.admin.change_logs.show.lot_name', number: lot.number, name: lot.name)
      )
    end

    if include_section_in_summary?(@change_log.change_type, *%i[update_supplier_framework_lot_rates add_rates_for_supplier_framework_lot_jurisdiction remove_rates_for_supplier_framework_lot_jurisdiction])
      summary_list_items << build_summary_item(
        t('shared.admin.change_logs.show.summary_list.jurisdiction'),
        Jurisdiction.where(id: @change_log.change_data['jurisdiction_id']).pick(:name)
      )
    end

    summary_list_items
  end
  # rubocop:enable Metrics/AbcSize

  UPDATE_SUPPLIER_INFORMATION_TABLE_ROWS = {
    name: [
      I18n.t('shared.admin.suppliers.show.basic_supplier_information.name'),
      ->(change_data) { change_data.key?('name') },
      ->(change_data) { change_data['name'] }
    ],
    duns_number: [
      I18n.t('shared.admin.suppliers.show.basic_supplier_information.duns'),
      ->(change_data) { change_data.key?('duns_number') },
      ->(change_data) { change_data['duns_number'] }
    ],
    sme: [
      I18n.t('shared.admin.suppliers.show.basic_supplier_information.is_sme'),
      ->(change_data) { change_data.key?('sme') },
      ->(change_data) { change_data['sme'] ? I18n.t('yes') : I18n.t('no') }
    ],
    trading_name: [
      I18n.t('shared.admin.suppliers.show.basic_supplier_information.trading_name'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('trading_name') },
      ->(change_data) { change_data.dig('additional_details', 'trading_name') }
    ],
    additional_identifier: [
      I18n.t('shared.admin.suppliers.show.basic_supplier_information.additional_identifier'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('additional_identifier') },
      ->(change_data) { change_data.dig('additional_details', 'additional_identifier') }
    ],
  }.freeze

  UPDATE_SUPPLIER_CONTACT_INFORMATION_TABLE_ROWS = {
    name: [
      I18n.t('shared.admin.suppliers.show.supplier_contact_information.contact_name'),
      ->(change_data) { change_data.key?('name') },
      ->(change_data) { change_data['name'] }
    ],
    email: [
      I18n.t('shared.admin.suppliers.show.supplier_contact_information.contact_email'),
      ->(change_data) { change_data.key?('email') },
      ->(change_data) { change_data['email'] }
    ],
    telephone_number: [
      I18n.t('shared.admin.suppliers.show.supplier_contact_information.telephone_number'),
      ->(change_data) { change_data.key?('telephone_number') },
      ->(change_data) { change_data['telephone_number'] }
    ],
    website: [
      I18n.t('shared.admin.suppliers.show.supplier_contact_information.website'),
      ->(change_data) { change_data.key?('website') },
      ->(change_data) { change_data['website'] }
    ],
  }.freeze

  UPDATE_SUPPLIER_ADDITIONAL_INFORMATION_TABLE_ROWS = {
    address: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.address'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('address') },
      ->(change_data) { change_data.dig('additional_details', 'address') }
    ],
    lot_1_prospectus_link: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_1_prospectus_link'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('lot_1_prospectus_link') },
      ->(change_data) { change_data.dig('additional_details', 'lot_1_prospectus_link') }
    ],
    lot_2_prospectus_link: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_2_prospectus_link'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('lot_2_prospectus_link') },
      ->(change_data) { change_data.dig('additional_details', 'lot_2_prospectus_link') }
    ],
    lot_3_prospectus_link: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_3_prospectus_link'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('lot_3_prospectus_link') },
      ->(change_data) { change_data.dig('additional_details', 'lot_3_prospectus_link') }
    ],
    lot_4a_prospectus_link: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_4a_prospectus_link'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('lot_4a_prospectus_link') },
      ->(change_data) { change_data.dig('additional_details', 'lot_4a_prospectus_link') }
    ],
    lot_4b_prospectus_link: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_4b_prospectus_link'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('lot_4b_prospectus_link') },
      ->(change_data) { change_data.dig('additional_details', 'lot_4b_prospectus_link') }
    ],
    lot_4c_prospectus_link: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_4c_prospectus_link'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('lot_4c_prospectus_link') },
      ->(change_data) { change_data.dig('additional_details', 'lot_4c_prospectus_link') }
    ],
    lot_5_prospectus_link: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.lot_5_prospectus_link'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('lot_5_prospectus_link') },
      ->(change_data) { change_data.dig('additional_details', 'lot_5_prospectus_link') }
    ],
    managed_service_provider_name: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.managed_service_provider_name'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('managed_service_provider_name') },
      ->(change_data) { change_data.dig('additional_details', 'managed_service_provider_name') }
    ],
    managed_service_provider_email: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.managed_service_provider_email'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('managed_service_provider_email') },
      ->(change_data) { change_data.dig('additional_details', 'managed_service_provider_email') }
    ],
    managed_service_provider_telephone: [
      I18n.t('shared.admin.suppliers.show.additional_supplier_information.managed_service_provider_telephone'),
      ->(change_data) { (change_data['additional_details'] || {}).key?('managed_service_provider_telephone') },
      ->(change_data) { change_data.dig('additional_details', 'managed_service_provider_telephone') }
    ],
  }.freeze

  UPDATE_SUPPLIER_FRAMEWORK_LOT_BRANCH_TABLE_ROWS = {
    name: [
      I18n.t('shared.admin.lot_data.edit.branches.branch_name'),
      ->(change_data) { change_data.key?('name') },
      ->(change_data) { change_data['name'] }
    ],
    region: [
      I18n.t('shared.admin.lot_data.edit.branches.branch_region'),
      ->(change_data) { change_data.key?('region') },
      ->(change_data) { change_data['region'] }
    ],
    contact_name: [
      I18n.t('shared.admin.lot_data.edit.branches.contact_name'),
      ->(change_data) { change_data.key?('contact_name') },
      ->(change_data) { change_data['contact_name'] }
    ],
    contact_email: [
      I18n.t('shared.admin.lot_data.edit.branches.contact_email'),
      ->(change_data) { change_data.key?('contact_email') },
      ->(change_data) { change_data['contact_email'] }
    ],
    telephone_number: [
      I18n.t('shared.admin.lot_data.edit.branches.telephone_number'),
      ->(change_data) { change_data.key?('telephone_number') },
      ->(change_data) { change_data['telephone_number'] }
    ],
    address_line_1: [
      I18n.t('shared.admin.lot_data.edit.branches.address_line_1'),
      ->(change_data) { change_data.key?('address_line_1') },
      ->(change_data) { change_data['address_line_1'] }
    ],
    address_line_2: [
      I18n.t('shared.admin.lot_data.edit.branches.address_line_2'),
      ->(change_data) { change_data.key?('address_line_2') },
      ->(change_data) { change_data['address_line_2'] }
    ],
    town: [
      I18n.t('shared.admin.lot_data.edit.branches.town'),
      ->(change_data) { change_data.key?('town') },
      ->(change_data) { change_data['town'] }
    ],
    county: [
      I18n.t('shared.admin.lot_data.edit.branches.county'),
      ->(change_data) { change_data.key?('county') },
      ->(change_data) { change_data['county'] }
    ],
    postcode: [
      I18n.t('shared.admin.lot_data.edit.branches.postcode'),
      ->(change_data) { change_data.key?('postcode') },
      ->(change_data) { change_data['postcode'] }
    ]
  }.freeze

  def update_supplier_information_table_rows
    @update_supplier_information_table_rows ||= collect_table_rows_for_change_type(ChangeLog::CHANGE_TYPES[:update_supplier_information], UPDATE_SUPPLIER_INFORMATION_TABLE_ROWS)
  end

  def update_supplier_contact_information_table_rows
    @update_supplier_contact_information_table_rows ||= collect_table_rows_for_change_type(ChangeLog::CHANGE_TYPES[:update_supplier_contact_information], UPDATE_SUPPLIER_CONTACT_INFORMATION_TABLE_ROWS)
  end

  def update_supplier_additional_information_table_rows
    @update_supplier_additional_information_table_rows ||= collect_table_rows_for_change_type(ChangeLog::CHANGE_TYPES[:update_supplier_additional_information], UPDATE_SUPPLIER_ADDITIONAL_INFORMATION_TABLE_ROWS)
  end

  def update_supplier_framework_lot_branch_table_rows
    @update_supplier_framework_lot_branch_table_rows ||= collect_table_rows(UPDATE_SUPPLIER_FRAMEWORK_LOT_BRANCH_TABLE_ROWS.keys, UPDATE_SUPPLIER_FRAMEWORK_LOT_BRANCH_TABLE_ROWS)
  end

  def update_supplier_framework_lot_item_list(item_ids, model, &)
    items = model.where(id: item_ids)

    category_names = items.pluck(:category)

    items.order(:name).group_by(&:category).sort_by { |category_name, _item| category_names.index(category_name) }.each(&)
  end

  def update_supplier_framework_lot_rates_table_rows
    @change_log.change_data['rates'].map do |rate_change|
      position = Position.find(rate_change['position_id'])

      [
        {
          text: t("shared.rates_table.#{@change_log.framework_id.downcase}.job_titles.#{position.name}")
        },
        {
          text: t("shared.rates_table.#{@change_log.framework_id.downcase}.categories.#{position.category || 'default'}")
        },
        {
          text: display_rate(rate_change['before'], position)
        },
        {
          text: display_rate(rate_change['after'], position)
        }
      ]
    end
  end

  def enabled_status_tag(is_enabled)
    if is_enabled
      [t('shared.admin.lot_data.summary.lot_status.enabled.enabled'), :green]
    elsif is_enabled == false
      [t('shared.admin.lot_data.summary.lot_status.enabled.disabled'), :red]
    else
      [t('shared.admin.lot_data.summary.lot_status.enabled.not_on_lot'), :yellow]
    end
  end

  private

  def build_summary_item(key_text, value_text)
    {
      key: { text: key_text },
      value: { text: value_text }
    }
  end

  def include_section_in_summary?(change_type, *allowed_change_types)
    allowed_change_types.any? { |key| ChangeLog::CHANGE_TYPES[key] == change_type }
  end

  alias_method :exclude_section_from_summary?, :include_section_in_summary?

  def collect_table_rows_for_change_type(change_type, table_rows_hash)
    collect_table_rows(change_type_attributes(change_type), table_rows_hash)
  end

  def collect_table_rows(attributes, table_rows_hash)
    attributes.filter_map do |attribute|
      key, attribute_present_func, value_func = table_rows_hash[attribute]

      next unless attribute_present_func.call(@change_log.change_data['before']) || attribute_present_func.call(@change_log.change_data['after'])

      [
        {
          text: key
        },
        {
          text: value_func.call(@change_log.change_data['before'])
        },
        {
          text: value_func.call(@change_log.change_data['after'])
        }
      ]
    end
  end

  def display_rate(rate, position)
    return if rate.nil?

    if position.rate_type == 'percentage'
      number_to_percentage(rate / 100.0, precision: 1)
    else
      format_money(rate / 100.0)
    end
  end
end
# rubocop:enable Metrics/ModuleLength
