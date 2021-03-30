module FacilitiesManagement
  module Admin
    class ManagementReport < ApplicationRecord
      include AASM

      belongs_to :user,
                 inverse_of: :management_reports

      acts_as_gov_uk_date :start_date, :end_date, error_clash_behaviour: :omit_gov_uk_date_field_error

      validate :dates_are_valid_dates
      validates :start_date, date: { before_or_equal_to: proc { Time.zone.today } }, presence: true
      validates :end_date, date: { before_or_equal_to: proc { Time.zone.today } }, presence: true

      has_one_attached :management_report_csv

      after_create :generate_report_csv

      aasm do
        state :generating_csv, initial: true
        state :completed

        event :complete do
          transitions from: :generating_csv, to: :completed
        end
      end

      private

      def generate_report_csv
        GenerateFMAdminReportJob.perform_later(id) unless management_report_csv.attached?
      end

      def dates_are_valid_dates
        start_date_valid_date
        end_date_valid_date

        return if @errors.any?

        @errors.add(:end_date, :must_be_before_start_date) unless start_date <= end_date
      end

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
  end
end
