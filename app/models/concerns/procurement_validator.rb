# rubocop:disable Metrics/ModuleLength
module ProcurementValidator
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    # Validations on regions and services
    validates :service_codes, presence: true, on: :service_codes
    validates :region_codes, presence: true, on: :region_codes

    # validations on :contract_name step
    with_options on: :contract_name do
      before_validation :remove_excess_whitespace_from_name
      validates :contract_name, presence: true
      validates :contract_name, uniqueness: { scope: :user }
      validates :contract_name, length: 1..100
    end

    # validations on :estimated_annual_cost step
    with_options on: :estimated_annual_cost do
      validates :estimated_cost_known, inclusion: { in: [true, false] }

      with_options if: -> { estimated_cost_known? } do
        validates :estimated_annual_cost, presence: true
        validates :estimated_annual_cost, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 999999999 }
      end
    end

    # validations on :procurement_buildings step
    validate :at_least_one_active_procurement_building, on: :buildings

    validate :service_code_selection, on: %i[services service_codes]

    validates :tupe, inclusion: { in: [true, false] }, on: %i[tupe]

    validates :payment_method, inclusion: { in: ['bacs', 'card'] }, on: %i[payment_method]

    validates :using_buyer_detail_for_invoice_details, inclusion: { in: [true, false] }, on: %i[invoicing_contact_details]

    validates :using_buyer_detail_for_authorised_detail, inclusion: { in: [true, false] }, on: %i[authorised_representative]

    validates :using_buyer_detail_for_notices_detail, inclusion: { in: [true, false] }, on: %i[notices_contact_details]

    validates :local_government_pension_scheme, inclusion: { in: [true, false] }, on: %i[local_government_pension_scheme]

    validates :governing_law, inclusion: { in: %w[english scottish northern_ireland] }, on: %i[governing_law]

    with_options on: :contract_period do
      validates :initial_call_off_period_years, presence: true, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7 }
      validates :initial_call_off_period_months, presence: true, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 11 }
      validate :initial_call_off_period_length

      validate :initial_call_off_start_date_present, :initial_call_off_start_date_real
      validates :initial_call_off_start_date, date: { after_or_equal_to: proc { Time.zone.today }, before: proc { Time.new(2100).in_time_zone('London') } }

      validates :mobilisation_period_required, inclusion: { in: [true, false] }
      validates :mobilisation_period, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 52 }, if: -> { mobilisation_period_required }

      validates :mobilisation_period_required, inclusion: { in: [true], message: :not_valid_with_tupe }, if: -> { tupe }
      validates :mobilisation_period, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 4, less_than_or_equal_to: 52 }, if: -> { tupe && mobilisation_period_required }

      validate  :mobilisation_start_date_validation, if: -> { mobilisation_period_required && initial_call_off_start_date.present? && mobilisation_period.present? && mobilisation_period <= 52 }

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

  def remove_excess_whitespace_from_name
    contract_name&.squish!
  end

  #############################################
  # Start of validation methods for contract-dates

  def initial_call_off_period_length
    return if errors[:initial_call_off_period_years].any? || errors[:initial_call_off_period_months].any?

    errors.add(:base, :total_contract_period) if initial_call_off_period > 7.years || initial_call_off_period.zero?
  end

  def initial_call_off_start_date_present
    errors.add(:initial_call_off_start_date, :blank) if initial_call_off_start_date_yyyy.blank? || initial_call_off_start_date_mm.blank? || initial_call_off_start_date_dd.blank?
  end

  def initial_call_off_start_date_real
    errors.add(:initial_call_off_start_date, :not_a_date) unless Date.valid_date?(initial_call_off_start_date_yyyy.to_i, initial_call_off_start_date_mm.to_i, initial_call_off_start_date_dd.to_i)
  end

  #############################################
  # Start of validation methods for contract-dates
  def validate_contract_data?
    initial_call_off_period_years.present? ? initial_call_off_period_years.positive? : false
  end

  def total_contract_length
    return if errors.any?

    start_date = mobilisation_period_required ? mobilisation_start_date : initial_call_off_start_date

    end_date = initial_call_off_end_date

    end_date += optional_call_off_extensions.select(&:extension_required).sum(&:period) if extensions_required

    return if end_date <= start_date + 10.years

    errors.add(:base, :total_contract_length)
  end

  def remove_empty_extensions
    return if errors.any?

    optional_call_off_extensions.reject(&:extension_required).each(&:delete)
  end

  # End of validation methods for contract-dates
  #############################################

  def at_least_one_active_procurement_building
    errors.add(:procurement_buildings, :invalid) unless procurement_buildings.map(&:active).any?(true)
  end

  def service_code_selection
    return errors.add(:service_codes, :invalid) if service_codes.blank?

    service_code_selection_validation
  end

  def service_code_selection_validation
    add_selection_error(service_code_selection_error_code)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def service_code_selection_error_code
    case service_codes.sort
    when ['O.1']
      0
    when ['N.1']
      1
    when ['M.1']
      2
    when ['M.1', 'O.1']
      3
    when ['N.1', 'O.1']
      4
    when ['M.1', 'N.1']
      5
    when ['M.1', 'N.1', 'O.1']
      6
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  const_set(:SERVICE_SELECTION_INVALID_TYPE, %i[invalid_billable invalid_helpdesk invalid_cafm invalid_cafm_billable invalid_helpdesk_billable invalid_cafm_helpdesk invalid_cafm_helpdesk_billable])

  def add_selection_error(index)
    return unless index

    errors.add(:service_codes, self.class::SERVICE_SELECTION_INVALID_TYPE[index])
  end

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

  def all_buildings_have_regions
    errors.add(:base, :missing_regions) if procurement_buildings_missing_regions?
  end

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

  def check_contract_period_completed
    if contract_period_status == :completed
      errors.add(:base, :initial_call_off_period_in_past) if contract_period_in_past?
      errors.add(:base, :mobilisation_period_in_past) if mobilisation_period_in_past?
      errors.add(:base, :mobilisation_period_required) unless mobilisation_period_valid_when_tupe_required?
    else
      errors.add(:base, :contract_period_incomplete)
    end
  end

  def check_service_and_buildings_present
    errors.add(:base, :services_incomplete) unless services_status == :completed
    errors.add(:base, :buildings_incomplete) unless buildings_status == :completed
  end

  def check_service_and_buildings_completed
    if (error_list & %i[services_incomplete buildings_incomplete]).any?
      errors.add(:base, :buildings_and_services_incomplete)
      errors.add(:base, :service_requirements_incomplete)
    elsif buildings_and_services_completed?
      errors.add(:base, :service_requirements_incomplete) unless service_requirements_completed?
    else
      errors.add(:base, :buildings_and_services_incomplete)
      errors.add(:base, :service_requirements_incomplete)
    end
  end

  def contract_period_in_past?
    initial_call_off_start_date < Time.now.in_time_zone('London').to_date
  end

  def mobilisation_period_in_past?
    return false unless mobilisation_period_required

    mobilisation_start_date.to_date <= Time.now.in_time_zone('London').to_date
  end

  def mobilisation_period_valid_when_tupe_required?
    return true unless tupe

    (mobilisation_period_required && mobilisation_period >= 4)
  end

  def error_list
    errors.details[:base].map { |detail| detail[:error] }
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

  def mobilisation_start_date_validation
    return unless mobilisation_period_in_past?

    errors.add(:mobilisation_start_date, :greater_than)
    errors.add(:mobilisation_period_required, '')
    errors.add(:initial_call_off_start_date, '')
  end

  def security_policy_document_file_ext_validation
    return unless security_policy_document_file.attached?

    errors.add(:security_policy_document_file, :wrong_extension) if VALID_FILE_EXTENSIONS.none? { |extension| security_policy_document_file.blob.filename.to_s.end_with?(extension) }
  end

  VALID_FILE_EXTENSIONS = ['.pdf', '.doc', '.docx'].freeze
end
# rubocop:enable Metrics/ModuleLength
