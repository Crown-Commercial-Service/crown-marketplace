class BankHoliday < ApplicationRecord
  def self.bank_holiday?(date)
    BankHoliday.where(date:).any?
  end
end
