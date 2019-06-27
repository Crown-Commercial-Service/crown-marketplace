class AddContactDetailsToManagementConsultancyRateCards < ActiveRecord::Migration[5.2]
  def change
    add_column :management_consultancy_rate_cards, :contact_name, :string
    add_column :management_consultancy_rate_cards, :telephone_number, :string
    add_column :management_consultancy_rate_cards, :email, :string
  end
end
