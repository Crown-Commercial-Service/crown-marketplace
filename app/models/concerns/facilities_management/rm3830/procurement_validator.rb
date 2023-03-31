# rubocop:disable Metrics/ModuleLength
module FacilitiesManagement::RM3830
  module ProcurementValidator
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/BlockLength
    included do
      # Validations on regions and services
      validates :service_codes, presence: true, on: :service_codes
      validates :region_codes, presence: true, on: :region_codes

      # validations on :estimated_annual_cost step
      with_options on: :estimated_annual_cost do
        validates :estimated_cost_known, inclusion: { in: [true, false] }

        with_options if: -> { estimated_cost_known? } do
          validates :estimated_annual_cost, presence: true
          validates :estimated_annual_cost, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 999999999 }
        end
      end

      validates :payment_method, inclusion: { in: ['bacs', 'card'] }, on: %i[payment_method]

      validates :using_buyer_detail_for_invoice_details, inclusion: { in: [true, false] }, on: %i[invoicing_contact_details]

      validates :using_buyer_detail_for_authorised_detail, inclusion: { in: [true, false] }, on: %i[authorised_representative]

      validates :using_buyer_detail_for_notices_detail, inclusion: { in: [true, false] }, on: %i[notices_contact_details]

      validates :local_government_pension_scheme, inclusion: { in: [true, false] }, on: %i[local_government_pension_scheme]

      validates :governing_law, inclusion: { in: %w[english scottish northern_ireland] }, on: %i[governing_law]

      with_options on: :contract_period do
        validates :extensions_required, inclusion: { in: [true, false] }

        after_validation :total_contract_length, :remove_empty_extensions
      end
      #
      # End of validation rules for contract-dates
      #############################################

      with_options on: :security_policy_document do
        validates :security_policy_document_required, inclusion: { in: [true, false] }

        with_options if: :security_policy_document_required? do
          validates :security_policy_document_name, presence: true
          validates :security_policy_document_version_number, presence: true
          validate :security_policy_document_date_valid?
          validates :security_policy_document_file, attached: true
        end

        validate :security_policy_document_file_ext_validation
        validates :security_policy_document_file, content_type: %w[application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document]
        validates :security_policy_document_file, size: { less_than: 10.megabytes }
        validates :security_policy_document_file, antivirus: true
      end

      # Additional validations for the 'Continue' button on the 'Detailed search summary' page - validating on :all
      with_options on: :continue do
        validate :all_buildings_have_regions
        validate :all_complete
      end

      # Validation for the contract_details page
      validate :validate_contract_details, on: :contract_details

      # Validation for the choose_contract_value page
      with_options on: :choose_contract_value do
        validates :lot_number, presence: true, inclusion: { in: %w[1a 1b 1c] }
        validate :lot_number_in_range
        validates :lot_number_selected_by_customer, acceptance: true
      end
    end
    # rubocop:enable Metrics/BlockLength

    private

    def security_policy_document_date_valid?
      errors.add(:security_policy_document_date, :not_a_date) unless all_security_policy_document_date_fields_valid?
    end

    def all_security_policy_document_date_fields_valid?
      return true if security_policy_document_date_yyyy.blank? && security_policy_document_date_mm.blank? && security_policy_document_date_dd.blank?

      return false if security_policy_document_date_yyyy.to_i < 1970

      Date.valid_date? security_policy_document_date_yyyy.to_i, security_policy_document_date_mm.to_i, security_policy_document_date_dd.to_i
    end

    def presence_of_about_the_contract
      errors.add(:contract_name, :not_present) if contract_name.blank?
      errors.add(:estimated_cost_known, :not_present) if estimated_cost_known.nil?
      errors.add(:tupe, :not_present) if tupe.nil?
    end

    def validate_contract_period_questions
      errors.add(:initial_call_off_period_years, :not_present) if initial_call_off_period_years.blank?
    end

    # Validations for continuing on the requirements summary page

    def all_complete
      return if errors.any? || building_data_frozen?

      check_contract_details_completed
      check_contract_period_completed
      check_service_and_buildings_present
      check_service_and_buildings_completed
    end

    def check_contract_details_completed
      errors.add(:base, :estimated_annual_cost_incomplete) unless estimated_annual_cost_status == :completed
      errors.add(:base, :tupe_incomplete) unless tupe_status == :completed
    end

    def check_service_and_buildings_completed
      if error_list.intersect?(%i[services_incomplete buildings_incomplete]) || !buildings_and_services_completed?
        errors.add(:base, :buildings_and_services_incomplete)
        errors.add(:base, :service_requirements_incomplete)
      else
        errors.add(:base, :service_requirements_incomplete) unless service_requirements_completed?
      end
    end

    def lot_number_in_range
      lot_number_in_correct_range = if assessed_value < 7000000
                                      true
                                    elsif assessed_value <= 50000000
                                      %w[1b 1c].include? lot_number
                                    else
                                      lot_number == '1c'
                                    end

      errors.add(:lot_number, :blank) unless lot_number_in_correct_range
    end

    def validate_contract_details
      CONTRACT_DETAILS.each do |contract_detail|
        errors.add(contract_detail, :not_present_contract_details) if send(contract_detail).nil?
      end

      errors.any?
    end

    CONTRACT_DETAILS = %i[payment_method using_buyer_detail_for_invoice_details using_buyer_detail_for_authorised_detail using_buyer_detail_for_notices_detail security_policy_document_required local_government_pension_scheme governing_law].freeze

    def security_policy_document_file_ext_validation
      return unless security_policy_document_file.attached?

      errors.add(:security_policy_document_file, :wrong_extension) if VALID_FILE_EXTENSIONS.none? { |extension| security_policy_document_file.blob.filename.to_s.end_with?(extension) }
    end

    VALID_FILE_EXTENSIONS = ['.pdf', '.doc', '.docx'].freeze
  end
end
# rubocop:enable Metrics/ModuleLength
