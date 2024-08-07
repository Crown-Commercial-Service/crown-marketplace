module FacilitiesManagement
  module RM3830
    class ProcurementPensionFund < ApplicationRecord
      belongs_to :procurement, class_name: 'FacilitiesManagement::RM3830::Procurement', foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :procurement_pension_funds, optional: true

      before_validation :remove_excess_whitespace_from_name
      validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :procurement }
      validates :name, length: { maximum: 150 }
      validates :percentage, presence: true
      validates :percentage, format: { with: /\A\d+\.*\d{0,4}\z/ }
      validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

      attribute :case_sensitive_error, :boolean, default: false
      validates_each :name do |record, attr|
        record.errors.add(attr, :taken) if record.case_sensitive_error == true
      end

      def name_downcase
        remove_excess_whitespace_from_name.downcase
      end

      def remove_excess_whitespace_from_name
        name&.squish!
      end
    end
  end
end
