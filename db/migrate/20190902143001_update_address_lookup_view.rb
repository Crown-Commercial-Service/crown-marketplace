class UpdateAddressLookupView < ActiveRecord::Migration[5.2]
  def change
    OrdnanceSurvey.create_address_lookup_view
  end
end
