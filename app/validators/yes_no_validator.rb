class YesNoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if %w[yes no].include?(value)

    record.errors.add attribute, :yes_no, options
  end
end
