class FacilitiesManagement::RM3830::ContractNumberGenerator
  ACRONYMS = { direct_award: 'DA', further_competition: 'FC' }.freeze

  def initialize(procurement_state:, framework:, used_numbers: [])
    @used_numbers = used_numbers
    @framework = framework
    @procurement_state = procurement_state
  end

  def new_number
    "#{@framework}-#{ACRONYMS[@procurement_state]}#{unique_number}-#{current_year}" if ACRONYMS.key?(@procurement_state)
  end

  private

  def unique_number
    potential_numbers = (1..9999).map { |integer| format('%04d', integer % 10000) }

    (potential_numbers - @used_numbers).sample
  end

  def current_year
    Date.current.year.to_s
  end
end
