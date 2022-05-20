class FacilitiesManagement::ContractNumberGenerator
  ACRONYMS = { direct_award: 'DA', further_competition: 'FC' }.freeze

  def initialize(framework:, model:, procurement_state: nil)
    @procurement_state = ACRONYMS[procurement_state]
    @framework = framework
    @model = model
    @extract_contract_number_function = @procurement_state ? :extract_contract_number_with_state : :extract_contract_number_without_state
  end

  def new_number
    return "#{@framework}-#{@procurement_state}#{unique_number(4)}-#{current_year}" if @procurement_state

    "#{@framework}-#{unique_number(6)}-#{current_year}"
  end

  private

  def unique_number(number_of_digits)
    potential_numbers =  ("#{'0' * (number_of_digits - 1)}1"..('9' * number_of_digits)).to_a

    (potential_numbers - used_contract_numbers_for_current_year).sample
  end

  def current_year
    Date.current.year.to_s
  end

  def extract_contract_number_with_state(contract_number)
    contract_number.split('-')[1].split(@procurement_state)[1]
  end

  def extract_contract_number_without_state(contract_number)
    contract_number.split('-')[1]
  end

  def used_contract_numbers_for_current_year
    @model.where('contract_number like ?', "#{@framework}-#{@procurement_state}%")
          .where('contract_number like ?', "%-#{current_year}")
          .pluck(:contract_number)
          .map { |contract_number| send(@extract_contract_number_function, contract_number) }
  end
end
