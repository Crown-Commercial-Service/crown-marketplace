module SupplyTeachers
  class Journey::FTAToPermCalculator
    include Steppable

    attribute :within_6_months
    validates :within_6_months, presence: true, inclusion: { in: %w[true false] }

    attribute :current_contract_length
    validates :current_contract_length,
              presence: true,
              numericality: { greater_than: 0, less_than: 12 }

    attribute :fixed_term_contract_fee
    validates :fixed_term_contract_fee, presence: true, numericality: { only_integer: true, greater_than: 0 }

    def next_step_class
      Journey::FTAToPermFee
    end
  end
end
