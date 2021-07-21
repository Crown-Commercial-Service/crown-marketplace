class FacilitiesManagement::ContractNumberGenerator
  ACRONYMS = { direct_award: 'DA', further_competition: 'FC' }.freeze

  def initialize(procurement_state:, framework:, model:)
    @procurement_state = ACRONYMS[procurement_state]
    @framework = framework
    @model = model
  end

  def new_number
    "#{@framework}-#{@procurement_state}#{unique_number}-#{current_year}" if @procurement_state
  end

  private

  def unique_number
    potential_numbers = (1..9999).map { |integer| format('%04d', integer % 10000) }

    (potential_numbers - used_contract_numbers_for_current_year).sample
  end

  def current_year
    Date.current.year.to_s
  end

  def used_contract_numbers_for_current_year
    @model.where('contract_number like ?', "#{@framework}-#{@procurement_state}%")
          .where('contract_number like ?', "%-#{current_year}")
          .pluck(:contract_number)
          .map { |contract_number| contract_number.split('-')[1].split(@procurement_state)[1] }
  end
end
