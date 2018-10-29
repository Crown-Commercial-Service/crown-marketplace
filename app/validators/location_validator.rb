class LocationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.found?

    record.errors.add attribute, :invalid_location
  end
end
