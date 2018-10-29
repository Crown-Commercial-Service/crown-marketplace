class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    postcode = UKPostcode.parse(value || '')
    return if postcode.valid?

    record.errors.add attribute, :invalid_postcode
  end
end
