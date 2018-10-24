class LocationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.valid?

    record.errors.add attribute, :invalid_location, options
  end
end
