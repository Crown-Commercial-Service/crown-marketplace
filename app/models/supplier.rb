class Supplier < ApplicationRecord
  has_many :supplier_frameworks, inverse_of: :supplier, class_name: 'Supplier::Framework', dependent: :destroy

  MAX_FIELD_LENGTH = 255
  ADDITIONAL_DETAILS_ATTRIBUTES = %i[trading_name additional_identifier].freeze

  store_accessor :additional_details, ADDITIONAL_DETAILS_ATTRIBUTES

  validates :name, presence: true, uniqueness: true
  validates :duns_number, uniqueness: true, allow_nil: true
  validate :validate_trading_name_is_unique, :validate_additional_identifier_is_unique

  with_options on: %i[basic_supplier_information] do
    before_validation :remove_excess_whitespace_from_name, :remove_excess_whitespace_from_duns_number, :remove_excess_whitespace_from_trading_name, :remove_excess_whitespace_from_additional_identifier

    validates :name, presence: true, uniqueness: true, length: { maximum: MAX_FIELD_LENGTH }, if: -> { self.class::ATTRIBUTES_TO_VALIDATE.include?(:name) }
    validates :duns_number, presence: true, uniqueness: true, format: { with: /\A\d{9}\z/ }, if: -> { self.class::ATTRIBUTES_TO_VALIDATE.include?(:duns_number) }
    validates :sme, inclusion: { in: [true, false] }, if: -> { self.class::ATTRIBUTES_TO_VALIDATE.include?(:sme) }
    validates :trading_name, presence: true, length: { maximum: MAX_FIELD_LENGTH }, if: -> { self.class::ATTRIBUTES_TO_VALIDATE.include?(:trading_name) }
    validates :additional_identifier, presence: true, length: { maximum: MAX_FIELD_LENGTH }, if: -> { self.class::ATTRIBUTES_TO_VALIDATE.include?(:additional_identifier) }
  end

  private

  %i[name duns_number trading_name additional_identifier].each do |attribute|
    define_method(:"remove_excess_whitespace_from_#{attribute}") { remove_excess_whitespace(attribute) }
  end

  %i[trading_name additional_identifier].each do |attribute|
    define_method(:"validate_#{attribute}_is_unique") { validate_field_is_unique(attribute) }
  end

  def remove_excess_whitespace(attribute)
    public_send(attribute)&.squish!
  end

  def validate_field_is_unique(attribute)
    value = public_send(attribute)

    return if value.blank?

    duplicates = Supplier.where('additional_details ->> ? = ?', attribute.to_s, value.to_s)

    duplicates = duplicates.where.not(id:) if persisted?

    errors.add(attribute, :taken) if duplicates.exists?
  end
end
