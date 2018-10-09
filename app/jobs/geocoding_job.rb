class GeocodingJob < ApplicationJob
  def perform(record)
    point = Geocoding.new.point(postcode: record.postcode)

    # We *need* to skip callbacks to avoid infinite recursion
    # rubocop:disable Rails/SkipsModelValidations
    record.update_column :location, point
    # rubocop:enable Rails/SkipsModelValidations
  end
end
