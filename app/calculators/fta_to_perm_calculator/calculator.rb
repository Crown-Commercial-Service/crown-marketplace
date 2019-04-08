require 'holidays'

module FTAToPermCalculator
  class Calculator
    attr_reader :within_6_months, :fixed_term_contract_fee, :current_contract_length

    def initialize(
      within_6_months:,
      fixed_term_contract_fee:,
      current_contract_length:
    )
      @within_6_months = within_6_months
      @fixed_term_contract_fee = fixed_term_contract_fee
      @current_contract_length = current_contract_length
    end

    def fee
      @within_6_months ? (@fixed_term_contract_fee / @current_contract_length) * 12 - @fixed_term_contract_fee : 0
    end
  end
end
