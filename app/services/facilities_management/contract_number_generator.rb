class FacilitiesManagement::ContractNumberGenerator
  ACRONYMS = { direct_award: 'DA', further_competition: 'FC' }.freeze

  def initialize(procurement_state:, used_numbers: [])
    @used_numbers = used_numbers
    @procurement_state = procurement_state
  end

  def new_number
    return "RM3830-#{ACRONYMS[@procurement_state]}#{unique_number_da}-#{current_year}" if ACRONYMS[@procurement_state] == 'DA'
    return "RM3830-#{ACRONYMS[@procurement_state]}#{unique_number_fc}-#{current_year}" if ACRONYMS[@procurement_state] == 'FC'
  end

  private

  def unique_number_da
    potential_numbers = (1..9999).map { |integer| format('%04d', integer % 10000) }

    (potential_numbers - @used_numbers).sample
  end

  def unique_number_fc
    potential_numbers = (1..999).map { |integer| format('%03d', integer % 1000) }

    (potential_numbers - @used_numbers).sample
  end

  def current_year
    Date.current.year.to_s
  end
end
