require 'holidays'

module FTAToPermCalculator
  class Calculator
    attr_reader :fixed_term_contract_fee, :current_contract_length

    def initialize(
      fixed_term_contract_fee:,
      current_contract_length:
    )
      @fixed_term_contract_fee = fixed_term_contract_fee
      @current_contract_length = current_contract_length
    end

    def fee
      (@fixed_term_contract_fee / @current_contract_length) * 12 - @fixed_term_contract_fee
    end
  end
end
