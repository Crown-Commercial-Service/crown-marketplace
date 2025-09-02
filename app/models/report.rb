class Report < ApplicationRecord
  include AASM

  belongs_to :user, inverse_of: :reports
  belongs_to :framework, inverse_of: :reports

  acts_as_gov_uk_date :start_date, :end_date, error_clash_behaviour: :omit_gov_uk_date_field_error

  validate :start_date_valid_date, :end_date_valid_date
  validates :start_date, date: { before_or_equal_to: proc { Time.zone.today } }, if: -> { errors[:start_date].none? }
  validates :end_date, date: { before_or_equal_to: proc { Time.zone.today }, after_or_equal_to: proc { :start_date } }, if: -> { errors.none? }

  has_one_attached :report_csv

  after_create :generate_report_csv

  aasm do
    state :generating_csv, initial: true
    state :completed
    state :failed

    event :complete do
      transitions from: :generating_csv, to: :completed
    end

    event :fail do
      transitions to: :failed
    end
  end

  def generate_report_csv
    ReportWorker.perform_async(id) unless report_csv.attached?
  end

  def short_uuid
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
