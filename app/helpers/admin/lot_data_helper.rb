module Admin::LotDataHelper
  def edit_page_heading
    @edit_page_heading ||= t('shared.admin.lot_data.edit.heading.heading', section: t("shared.admin.lot_data.edit.heading.#{@section}"))
  end

  def edit_page_error_summary
    if @section == :rates
      rates_error_summary
    else
      render(partial: 'shared/error_summary', locals: { errors: @model.errors })
    end
  end

  def rates_error_summary
    error_summary = []

    @supplier_framework_lot_rates.each do |position_id, supplier_framework_lot_rate|
      next if supplier_framework_lot_rate.errors[:rate].blank?

      error_summary << {
        text: supplier_framework_lot_rate.errors[:rate].first,
        href: "##{error_id("supplier_framework_lot[rates][#{position_id}]")}"
      }
    end

    govuk_error_summary(t('shared.error_summary.there_is_a_problem'), error_summary) if error_summary.any?
  end

  def services_lot_title(supplier_lot_data_item)
    t('shared.admin.lot_data.index.supplier_lot_data_summary_list.lot_name', **supplier_lot_data_item[:lot])
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

  def label_for_table_header(input)
    input.send(:form_group).render do |display_error_message|
      concat(input.send(:label).render)
      concat(input.send(:hint).render) if input.send(:hint)
      concat(display_error_message)
    end
  end

  def input_for_table_cell(input)
    input.send(:text_input_wrapper) do
      text_field_tag(input.send(:attribute), input.send(:value), **input.send(:options)[:attributes])
    end
  end

  # rubocop:disable Metrics/AbcSize
  def create_rate_input(position, rates, translation_func, category = nil)
    rate = rates[position.id]

    attributes = {
      attribute: :"supplier_framework_lot[rates][#{position.id}]",
      label: {
        classes: 'govuk-!-font-weight-bold'
      },
      error_message: rate.errors[:rate].first,
      value: if rate.rate.nil?
               nil
             else
               number_with_precision(rate.normalized_rate, precision: rate.rate_type == 'percentage' ? 1 : 2)
             end,
      attributes: {
        aria: {
          describedby: aria_describedby_id(category)
        }
      },
      classes: 'govuk-input--width-5'
    }

    if rate.mandatory
      attributes[:label][:text] = translation_func.call(position)
    else
      attributes[:label][:text] = t('shared.admin.lot_data.edit.rates.optional', label: translation_func.call(position))
      attributes[:hint] = {
        text: t('shared.admin.lot_data.edit.rates.hint')
      }
    end

    if rate.rate_type == 'percentage'
      attributes[:suffix] = { text: '%' }
    else
      attributes[:prefix] = { text: '£' }
    end

    CCS::Components::GovUK::Field::Input::TextInput.new(context: self, **attributes)
  end
  # rubocop:enable Metrics/AbcSize

  def aria_describedby_id(category = nil)
    "ccs-rates-table--rate-type#{"--#{category&.downcase&.gsub('_', '-')}" if category}"
  end

  def additional_form_params
    %i[jurisdiction_id branch_id].each do |key|
      return { "#{key}": params[key] } if params[key]
    end

    {}
  end
end
