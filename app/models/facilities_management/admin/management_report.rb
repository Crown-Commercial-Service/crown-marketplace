class FacilitiesManagement::Admin::ManagementReport < ApplicationRecord
  include AASM

  self.abstract_class = true

  validate :start_date_valid_date, :end_date_valid_date
  validates :start_date, date: { before_or_equal_to: proc { Time.zone.today } }, if: -> { errors[:start_date].none? }
  validates :end_date, date: { before_or_equal_to: proc { Time.zone.today }, after_or_equal_to: proc { :start_date } }, if: -> { errors.none? }

  has_one_attached :management_report_csv

  after_create :generate_report_csv

  aasm do
    state :generating_csv, initial: true
    state :completed

    event :complete do
      transitions from: :generating_csv, to: :completed
    end
  end

  def short_id
    "##{id[..7]}"
  end

  private

  def end_date_valid_date
    Date.parse("#{end_date_dd.to_i}/#{end_date_mm.to_i}/#{end_date_yyyy.to_i}")
  rescue ArgumentError
    errors.add(:end_date, :not_a_date)
  end

  def start_date_valid_date
    Date.parse("#{start_date_dd.to_i}/#{start_date_mm.to_i}/#{start_date_yyyy.to_i}")
  rescue ArgumentError
    errors.add(:start_date, :not_a_date)
  end
end
