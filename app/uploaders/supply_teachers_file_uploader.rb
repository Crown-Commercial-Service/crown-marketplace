class SupplyTeachersFileUploader < CarrierWave::Uploader::Base
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "data/supply_teachers/#{mounted_as}/#{model.id}"
  end

  def size_range
    1..5.megabytes
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[xls xlsx csv]
  end

end
