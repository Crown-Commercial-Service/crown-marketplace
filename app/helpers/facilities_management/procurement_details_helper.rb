module FacilitiesManagement
  module ProcurementDetailsHelper
    include ContractDatesHelper

    def initial_call_off_period_error?
      @procurement.errors[:initial_call_off_period_years].any? || @procurement.errors[:initial_call_off_period_months].any? || total_contract_period_error?
    end

    def total_contract_period_error?
      @total_contract_period_error ||= @procurement.errors[:base] && @procurement.errors.details[:base].any? { |error| error[:error] == :total_contract_period }
    end

    def extension_periods_error?
      %i[extensions_required call_off_extensions.months call_off_extensions.years call_off_extensions.base].any? { |extension_error| @procurement.errors.attribute_names.include? extension_error }
    end

    def total_contract_length_error?
      @total_contract_length_error ||= @procurement.errors[:base] && @procurement.errors.details[:base].any? { |error| error[:error] == :total_contract_length }
    end

    def display_extension_error_anchor
      error_list = []

      %i[years months base].each do |attribute|
        error_list << "call_off_extensions.#{attribute}-error" if @procurement.errors.include?(:"call_off_extensions.#{attribute}")
      end

      error_list.each do |error|
        concat(tag.span(id: error))
      end
    end

    def call_off_extensions
      @call_off_extensions ||= @procurement.call_off_extensions.sort_by(&:extension)
    end

    def call_off_extension_visible?(extension)
      return false unless @procurement.extensions_required

      call_off_extension = call_off_extensions.find { |optional_extension| optional_extension.extension == extension }

      return false unless call_off_extension

      call_off_extension_meet_conditions?(call_off_extension)
    end

    def call_off_extension_meet_conditions?(call_off_extension)
      call_off_extension.extension_required || call_off_extension.years.present? || call_off_extension.months.present? || call_off_extension.errors.any?
    end

    def procurement_building_row(form, building)
      if building.status == 'Ready'
        tag.div(class: 'govuk-checkboxes govuk-checkboxes--small') do
          tag.div(class: 'govuk-checkboxes__item') do
            capture do
              concat(form.check_box(:active, class: 'govuk-checkboxes__input', title: building.building_name, checked: @building_params[building.id] == '1'))
              concat(form.label(:active, class: 'govuk-label govuk-checkboxes__label govuk-!-padding-top-0') do
                procurement_building_checkbox_text(building)
              end)
            end
          end
        end
      else
        tag.div(class: 'govuk-!-padding-left-7') do
          procurement_building_checkbox_text(building)
        end
      end
    end

    def procurement_building_checkbox_text(building)
      capture do
        concat(tag.span(building.building_name, class: 'govuk-fieldset__legend'))
        concat(tag.span(building.address_no_region, class: 'govuk-hint govuk-!-margin-bottom-0'))
      end
    end

    def address_in_a_line(building)
      [building.address_line_1, building.address_line_2, building.address_town].compact_blank.join(', ') + " #{building.address_postcode}"
    end

    def edit_page_title
      @edit_page_title ||= t("facilities_management.procurement_details.edit.title.#{section}")
    end

    def show_page_title
      @show_page_title ||= t("facilities_management.procurement_details.show.title.#{section}")
    end

    def new_building_path
      "/facilities-management/#{params[:framework]}/procurements/#{params[:procurement_id]}/edit-buildings/new"
    end

    def show_building_path(building_id)
      "/facilities-management/#{params[:framework]}/procurements/#{params[:procurement_id]}/edit-buildings/#{building_id}"
    end
  end
end
