class AddServiceCodeToLegalServicesRegionalAvailabilities < ActiveRecord::Migration[5.2]
  def change
    add_column :legal_services_regional_availabilities, :service_code, :string
  end
end
