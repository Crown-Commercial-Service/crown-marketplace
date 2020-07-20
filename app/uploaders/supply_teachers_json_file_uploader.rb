class SupplyTeachersJsonFileUploader < CarrierWave::Uploader::Base
  storage Rails.env.production? ? :aws : :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "supply_teachers/current_data/#{mounted_as}/#{model.id}"
  end

  def size_range
    1..5.megabytes
  end

  # Add a safe list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_safelist
    %w[json]
  end

  def cache_dir
    Rails.root.join('storage', 'supply_teachers', 'tmp', 'current_uploads')
  end
end
