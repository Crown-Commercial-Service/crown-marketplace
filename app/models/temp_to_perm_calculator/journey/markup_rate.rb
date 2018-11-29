module TempToPermCalculator
  class Journey::MarkupRate
    include ::Journey::Step

    attribute :markup_rate
    validates :markup_rate,
              presence: true,
              numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

    def next_step_class
      Journey::Fee
    end
  end
end
