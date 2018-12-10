module SupplyTeachers
  class Journey::TempToPermCalculator
    include Steppable

    attribute :contract_start_date_day
    attribute :contract_start_date_month
    attribute :contract_start_date_year
    validates :contract_start_date, presence: true

    attribute :days_per_week
    validates :days_per_week,
              presence: true,
              numericality: { greater_than: 0, less_than_or_equal_to: 5 }

    attribute :day_rate
    validates :day_rate, presence: true, numericality: { only_integer: true, greater_than: 0 }

    attribute :markup_rate
    validates :markup_rate,
              presence: true,
              numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

    attribute :hire_date_day
    attribute :hire_date_month
    attribute :hire_date_year
    validates :hire_date, presence: true

    attribute :holiday_1_start_date_day
    attribute :holiday_1_start_date_month
    attribute :holiday_1_start_date_year
    validates :holiday_1_start_date,
              presence: {
                if: proc do |calculator|
                  calculator.holiday_1_start_date_day.present? ||
                    calculator.holiday_1_start_date_month.present? ||
                    calculator.holiday_1_start_date_year.present?
                end,
                message: :invalid
              }

    attribute :holiday_1_end_date_day
    validates :holiday_1_end_date_day,
              numericality: {
                allow_blank: true, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31
              }
    attribute :holiday_1_end_date_month
    validates :holiday_1_end_date_month,
              numericality: {
                allow_blank: true, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12
              }
    attribute :holiday_1_end_date_year
    validates :holiday_1_end_date_year,
              numericality: { allow_blank: true, only_integer: true }

    attribute :holiday_2_start_date_day
    validates :holiday_2_start_date_day,
              numericality: {
                allow_blank: true, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31
              }
    attribute :holiday_2_start_date_month
    validates :holiday_2_start_date_month,
              numericality: {
                allow_blank: true, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12
              }
    attribute :holiday_2_start_date_year
    validates :holiday_2_start_date_year,
              numericality: { allow_blank: true, only_integer: true }

    attribute :holiday_2_end_date_day
    validates :holiday_2_end_date_day,
              numericality: {
                allow_blank: true, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31
              }
    attribute :holiday_2_end_date_month
    validates :holiday_2_end_date_month,
              numericality: {
                allow_blank: true, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12
              }
    attribute :holiday_2_end_date_year
    validates :holiday_2_end_date_year,
              numericality: { allow_blank: true, only_integer: true }

    attribute :notice_date_day
    validates :notice_date_day,
              numericality: {
                allow_blank: true, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31
              }
    attribute :notice_date_month
    validates :notice_date_month,
              numericality: {
                allow_blank: true, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12
              }
    attribute :notice_date_year
    validates :notice_date_year,
              numericality: { allow_blank: true, only_integer: true }

    validate :ensure_hire_date_is_after_contract_start_date

    def next_step_class
      Journey::TempToPermFee
    end

    def contract_start_date
      Date.parse("#{contract_start_date_year}-#{contract_start_date_month}-#{contract_start_date_day}")
    rescue ArgumentError
      nil
    end

    def hire_date
      Date.parse("#{hire_date_year}-#{hire_date_month}-#{hire_date_day}")
    rescue ArgumentError
      nil
    end

    def notice_date
      Date.parse("#{notice_date_year}-#{notice_date_month}-#{notice_date_day}")
    rescue ArgumentError
      nil
    end

    def holiday_1_start_date
      Date.parse("#{holiday_1_start_date_year}-#{holiday_1_start_date_month}-#{holiday_1_start_date_day}")
    rescue ArgumentError
      nil
    end

    def holiday_1_end_date
      Date.parse("#{holiday_1_end_date_year}-#{holiday_1_end_date_month}-#{holiday_1_end_date_day}")
    rescue ArgumentError
      nil
    end

    def holiday_2_start_date
      Date.parse("#{holiday_2_start_date_year}-#{holiday_2_start_date_month}-#{holiday_2_start_date_day}")
    rescue ArgumentError
      nil
    end

    def holiday_2_end_date
      Date.parse("#{holiday_2_end_date_year}-#{holiday_2_end_date_month}-#{holiday_2_end_date_day}")
    rescue ArgumentError
      nil
    end

    private

    def ensure_hire_date_is_after_contract_start_date
      return if hire_date.blank? || contract_start_date.blank?
      return if hire_date > contract_start_date

      errors.add(:hire_date, :after_contract_start_date)
    end
  end
end
