module FacilitiesManagement
  module DetailsHelper
    include ContractDatesHelper

    def initial_call_off_period_error?
      @procurement.errors[:initial_call_off_period_years].any? || @procurement.errors[:initial_call_off_period_months].any? || total_contract_period_error?
    end

    def total_contract_period_error?
      @total_contract_period_error ||= @procurement.errors[:base] && @procurement.errors.details[:base].any? { |error| error[:error] == :total_contract_period }
    end

    def extension_periods_error?
      %i[extensions_required call_off_extensions.months call_off_extensions.years call_off_extensions.base].any? { |extension_error| @procurement.errors.keys.include? extension_error }
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
  end
end
