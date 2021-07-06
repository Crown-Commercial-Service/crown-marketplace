module FacilitiesManagement
  class Procurement < ApplicationRecord
    include ProcurementValidator

    self.abstract_class = true

    has_many :optional_call_off_extensions, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :optional_call_off_extensions, allow_destroy: true

    has_many :procurement_buildings, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    has_many :active_procurement_buildings, -> { where(active: true) }, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementBuilding', inverse_of: :procurement, dependent: :destroy
    has_many :procurement_building_services, through: :active_procurement_buildings
    accepts_nested_attributes_for :procurement_buildings, allow_destroy: true

    has_many :procurement_suppliers, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy

    has_one :spreadsheet_import, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy

    has_one :invoice_contact_detail, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementInvoiceContactDetail', inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :invoice_contact_detail, allow_destroy: true

    has_one :authorised_contact_detail, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementAuthorisedContactDetail', inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :authorised_contact_detail, allow_destroy: true

    has_one :notices_contact_detail, foreign_key: :facilities_management_procurement_id, class_name: 'FacilitiesManagement::ProcurementNoticesContactDetail', inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :notices_contact_detail, allow_destroy: true

    has_many :procurement_pension_funds, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy, index_errors: true, before_add: :before_each_procurement_pension_funds
    accepts_nested_attributes_for :procurement_pension_funds, allow_destroy: true, reject_if: :more_than_max_pensions?

    acts_as_gov_uk_date :initial_call_off_start_date, :security_policy_document_date, error_clash_behaviour: :omit_gov_uk_date_field_error

    has_one_attached :security_policy_document_file

    before_save :update_procurement_building_services, if: :service_codes_changed?

    # For making a copy of a procurement
    amoeba do
      exclude_association :procurement_suppliers
      exclude_association :active_procurement_buildings
    end

    def self.used_further_competition_contract_numbers_for_current_year
      where('contract_number like ?', "#{framework}-FC%")
        .where('contract_number like ?', "%-#{Date.current.year}")
        .pluck(:contract_number)
        .map { |contract_number| contract_number.split('-')[1].split('FC')[1] }
    end

    private

    def assign_contract_number_fc
      self.contract_number = generate_contract_number_fc
    end

    def assign_contract_datetime
      self.contract_datetime = Time.now.in_time_zone('London').strftime('%d/%m/%Y -%l:%M%P')
    end

    def generate_contract_number_fc
      ContractNumberGenerator.new(procurement_state: :further_competition, framework: framework, used_numbers: self.class.used_further_competition_contract_numbers_for_current_year).new_number
    end

    def before_each_procurement_pension_funds(new_pension_fund)
      new_pension_fund.case_sensitive_error = false
      procurement_pension_funds.each do |saved_pension_fund|
        new_pension_fund.case_sensitive_error = true if (saved_pension_fund.name_downcase == new_pension_fund.name_downcase) && (saved_pension_fund.object_id != new_pension_fund.object_id)
      end
    end

    def update_procurement_building_services
      procurement_buildings.each do |building|
        building.service_codes.select! { |service_code| service_codes&.include? service_code }
      end
      procurement_building_services.where.not(code: service_codes).destroy_all
    end

    # Methods which concern contract dates
    def initial_call_off_period
      initial_call_off_period_years.years + initial_call_off_period_months.months
    end

    def initial_call_off_end_date
      period_end_date(initial_call_off_start_date, initial_call_off_period)
    end

    def mobilisation_start_date
      mobilisation_end_date - mobilisation_period.weeks
    end

    def mobilisation_end_date
      initial_call_off_start_date - 1.day
    end

    def extension_period_start_date(extension)
      initial_call_off_end_date + optional_call_off_extensions.where(extension: (0..(extension - 1))).sum(&:period) + 1.day
    end

    def extension_period_end_date(extension)
      initial_call_off_end_date + optional_call_off_extensions.where(extension: (0..extension)).sum(&:period)
    end

    def optional_call_off_extension(extension)
      optional_call_off_extensions.find_by(extension: extension)
    end

    def build_optional_call_off_extensions
      (0..3).each do |extension|
        optional_call_off_extensions.find_or_initialize_by(extension: extension)
      end
    end
  end
end
