module FacilitiesManagement::RM3830::Admin
  class RateValidator
    include ActiveModel::Validations

    attr_reader :rate

    validates :rate, presence: true, unless: -> { @allow_blank }

    with_options unless: -> { rate.blank? } do
      validates :rate, numericality: { greater_than_or_equal_to: 0 }

      with_options on: :full_range do
        validates :rate, numericality: { less_than_or_equal_to: 1 }
        validates :rate, format: { with: /\A\d+(\.\d{1,20})?\z/, error: :more_than_max_decimals }
      end
    end

    def initialize(rate, allow_blank = true)
      @rate = rate
      @allow_blank = allow_blank
    end

    def error_type
      errors.details[:rate].first[:error].to_s
    end
  end
end
