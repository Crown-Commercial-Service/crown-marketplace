module DateValidations
  extend ActiveSupport::Concern

  private

  included do
    self::DATE_ATTIBUTES.each do |attribute|
      define_method attribute do
        Date.strptime(
          "#{send("#{attribute}_yyyy")}-#{send("#{attribute}_mm")}-#{send("#{attribute}_dd")}",
          PARSED_DATE_FORMAT
        )
      rescue ArgumentError
        nil
      end
    end
  end

  PARSED_DATE_FORMAT = '%Y-%m-%d'.freeze

  def ensure_date_valid(attribute, allow_blank = true)
    year = send("#{attribute}_yyyy")
    month = send("#{attribute}_mm")
    day = send("#{attribute}_dd")

    return if allow_blank && [year, month, day].none?(&:present?)

    errors.add(attribute, :invalid) unless Date.valid_date?(year.to_i, month.to_i, day.to_i)
  end

  def ensure_date_is_after(first_date, second_date, attribute, error)
    return if first_date.blank? || second_date.blank?
    return if first_date >= second_date

    errors.add(attribute, error)
  end
end
