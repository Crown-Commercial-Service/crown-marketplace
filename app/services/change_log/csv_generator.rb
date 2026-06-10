class ChangeLog::CsvGenerator
  HEADERS = [
    I18n.t('shared.admin.change_logs.index.change_logs_table.log_item'),
    I18n.t('shared.admin.change_logs.index.change_logs_table.change_type'),
    I18n.t('shared.admin.change_logs.index.change_logs_table.changed_by'),
    I18n.t('shared.admin.change_logs.index.change_logs_table.changed_at'),
    I18n.t('shared.admin.change_logs.show.summary_list.supplier_name'),
    I18n.t('shared.admin.change_logs.show.summary_list.lot'),
    I18n.t('shared.admin.change_logs.show.summary_list.jurisdiction'),
    I18n.t('shared.admin.change_logs.show.change_table.attribute'),
    I18n.t('shared.admin.change_logs.show.change_table.position'),
    I18n.t('shared.admin.change_logs.show.change_table.rate_type'),
    "#{I18n.t('shared.admin.change_logs.show.change_table.before')}/#{I18n.t('shared.admin.change_logs.change_log_csv.headings.removed')}",
    "#{I18n.t('shared.admin.change_logs.show.change_table.after')}/#{I18n.t('shared.admin.change_logs.change_log_csv.headings.added')}",
  ].freeze

  def initialize(framework_id, view_context)
    @framework = Framework.find(framework_id)
    @view_context = view_context
  end

  def generate_csv
    CSV.generate do |csv|
      csv << HEADERS

      ChangeLog.includes(:user).where(framework_id: @framework.id).order(created_at: :desc).each do |change_log|
        generate_rows_for_change_log(change_log) do |row|
          csv << row
        end
      end
    end
  end

  private

  def generate_rows_for_change_log(change_log, &)
    change_log_row_start = generate_change_log_row_start(change_log)

    send(:"change_log_row_for_#{change_log.change_type}", change_log) do |row|
      yield change_log_row_start + row
    end
  end

  def generate_change_log_row_start(change_log)
    [
      change_log.short_id,
      I18n.t("shared.admin.change_logs.change_types.#{change_log.change_type}"),
      change_log.changed_by,
      @view_context.format_date_time(change_log.created_at).squish,
      maybe_supplier_name(change_log),
      maybe_lot_name(change_log),
      maybe_jurisdiction(change_log),
    ]
  end

  def change_log_row_for_upload_supplier_data(change_log, &)
    yield [
      nil,
      nil,
      nil,
      nil,
      "#{Marketplace.rails_env_url}/#{@framework.service.dasherize}/#{@framework.id}/admin/uploads/#{change_log.change_data['admin_upload_id']}"
    ]
  end

  def change_log_row_for_update_supplier_information(change_log, &)
    change_log_row_for_supplier_information_log(change_log, Admin::ChangeLogsHelper::UPDATE_SUPPLIER_INFORMATION_TABLE_ROWS, &)
  end

  def change_log_row_for_update_supplier_contact_information(change_log, &)
    change_log_row_for_supplier_information_log(change_log, Admin::ChangeLogsHelper::UPDATE_SUPPLIER_CONTACT_INFORMATION_TABLE_ROWS, &)
  end

  def change_log_row_for_update_supplier_additional_information(change_log, &)
    change_log_row_for_supplier_information_log(change_log, Admin::ChangeLogsHelper::UPDATE_SUPPLIER_ADDITIONAL_INFORMATION_TABLE_ROWS, &)
  end

  def change_log_row_for_supplier_information_log(change_log, attribute_rows, &)
    attribute_rows.each_value do |attribute, attribute_present_func, value_func|
      next unless attribute_present_func.call(change_log.change_data['before']) || attribute_present_func.call(change_log.change_data['after'])

      yield [
        attribute,
        nil,
        nil,
        value_func.call(change_log.change_data['before']),
        value_func.call(change_log.change_data['after'])
      ]
    end
  end

  def change_log_row_for_update_supplier_framework_lot_status(change_log, &)
    yield [
      I18n.t('shared.admin.change_logs.change_types.update_supplier_framework_lot_status'),
      nil,
      nil,
      @view_context.enabled_status_tag(change_log.change_data['before']['enabled'])[0],
      @view_context.enabled_status_tag(change_log.change_data['after']['enabled'])[0]
    ]
  end

  def change_log_row_for_update_supplier_framework_lot_services(change_log, &)
    yield [
      I18n.t('shared.admin.change_logs.change_log_csv.change_log_attributes.services'),
      nil,
      nil,
      formatted_items(change_log.change_data['removed'], Service),
      formatted_items(change_log.change_data['added'], Service),
    ]
  end

  def change_log_row_for_update_supplier_framework_lot_jurisdictions(change_log, &)
    yield [
      I18n.t('shared.admin.change_logs.change_log_csv.change_log_attributes.jurisdictions'),
      nil,
      nil,
      formatted_items(change_log.change_data['removed'], Jurisdiction),
      formatted_items(change_log.change_data['added'], Jurisdiction),
    ]
  end

  def change_log_row_for_rates_log(change_log, &)
    change_log.change_data['rates'].each do |rate_change|
      position = fetch_position(change_log.change_data['lot_id'], rate_change['position_id'])

      yield [
        I18n.t('shared.admin.change_logs.change_log_csv.change_log_attributes.rate'),
        I18n.t("shared.rates_table.#{change_log.framework_id.downcase}.job_titles.#{position.name}"),
        I18n.t("shared.rates_table.#{change_log.framework_id.downcase}.categories.#{position.category || 'default'}"),
        @view_context.send(:display_rate, rate_change['before'], position),
        @view_context.send(:display_rate, rate_change['after'], position),
      ]
    end
  end

  alias_method :change_log_row_for_update_supplier_framework_lot_rates, :change_log_row_for_rates_log

  def change_log_row_for_update_supplier_framework_lot_branch(change_log, &)
    change_log_row_for_supplier_information_log(change_log, Admin::ChangeLogsHelper::UPDATE_SUPPLIER_FRAMEWORK_LOT_BRANCH_TABLE_ROWS, &)
  end

  alias_method :change_log_row_for_add_rates_for_supplier_framework_lot_jurisdiction, :change_log_row_for_rates_log

  alias_method :change_log_row_for_remove_rates_for_supplier_framework_lot_jurisdiction, :change_log_row_for_rates_log

  def maybe_supplier_name(change_log)
    return if @view_context.send(:exclude_section_from_summary?, change_log.change_type, :upload_supplier_data)

    change_log.change_data['supplier_name']
  end

  def maybe_lot_name(change_log)
    return unless @view_context.send(:include_section_in_summary?, change_log.change_type, *%i[update_supplier_framework_lot_status update_supplier_framework_lot_services update_supplier_framework_lot_rates update_supplier_framework_lot_jurisdictions update_supplier_framework_lot_branch add_rates_for_supplier_framework_lot_jurisdiction remove_rates_for_supplier_framework_lot_jurisdiction])

    lot = fetch_lot(change_log.change_data['lot_id'])

    I18n.t('shared.admin.change_logs.show.lot_name', number: lot.number, name: lot.name)
  end

  def maybe_jurisdiction(change_log)
    return unless @view_context.send(:include_section_in_summary?, change_log.change_type, *%i[update_supplier_framework_lot_rates add_rates_for_supplier_framework_lot_jurisdiction remove_rates_for_supplier_framework_lot_jurisdiction])

    fetch_jurisdiction_name(change_log.change_data['jurisdiction_id'])
  end

  def formatted_items(item_ids, model)
    items_list = []

    if item_ids.any?
      @view_context.update_supplier_framework_lot_item_list(item_ids, model) do |group, items|
        items_list << "#{group}:" unless group.nil?

        items.each do |item|
          items_list << "#{item.name};"
        end
      end
    end

    items_list.join("\n")
  end

  def fetch_lot(lot_id)
    (@fetch_lot ||= {})[lot_id] ||= Lot.find(lot_id)
  end

  def fetch_jurisdiction_name(jurisdiction_id)
    (@fetch_jurisdiction_name ||= {})[jurisdiction_id] ||= Jurisdiction.where(id: jurisdiction_id).pick(:name)
  end

  def fetch_position(lot_id, position_id)
    ((@fetch_position ||= {})[lot_id] ||= Position.where(lot_id:).select(:id, :name, :category, :rate_type).index_by(&:id))[position_id]
  end
end
