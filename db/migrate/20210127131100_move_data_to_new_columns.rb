class MoveDataToNewColumns < ActiveRecord::Migration[5.2]
  def self.up
    FacilitiesManagement::Procurement.reset_column_information
    FacilitiesManagement::Procurement::OptionalCallOffExtension.reset_column_information

    FacilitiesManagement::Procurement.where(extensions_required: true).where(aasm_state: %w[detailed_search detailed_search_bulk_upload choose_contract_value results da_draft direct_award further_competition closed]).find_in_batches do |group|
      sleep(5)

      group.each { |procurement| add_years_and_months(procurement) }
    end

    remove_column :facilities_management_procurements, :optional_call_off_extensions_1
    remove_column :facilities_management_procurements, :optional_call_off_extensions_2
    remove_column :facilities_management_procurements, :optional_call_off_extensions_3
    remove_column :facilities_management_procurements, :optional_call_off_extensions_4
  end

  def self.down
    add_column :facilities_management_procurements, :optional_call_off_extensions_1, :integer
    add_column :facilities_management_procurements, :optional_call_off_extensions_2, :integer
    add_column :facilities_management_procurements, :optional_call_off_extensions_3, :integer
    add_column :facilities_management_procurements, :optional_call_off_extensions_4, :integer

    FacilitiesManagement::Procurement.reset_column_information
    FacilitiesManagement::Procurement::OptionalCallOffExtension.reset_column_information

    FacilitiesManagement::Procurement.where(extensions_required: true).where(aasm_state: %w[detailed_search detailed_search_bulk_upload choose_contract_value results da_draft direct_award further_competition closed]).find_in_batches do |group|
      sleep(5)

      group.each { |procurement| remove_years_and_months(procurement) }
    end
  end

  def self.add_years_and_months(procurement)
    (1..4).each do |period|
      extenion_period_year = procurement.send("optional_call_off_extensions_#{period}")
      break unless extenion_period_year

      procurement.optional_call_off_extensions.create(extension: period - 1, years: extenion_period_year, months: 0)
    end
  end

  def self.remove_years_and_months(procurement)
    procurement.optional_call_off_extensions.sorted.each do |extenion_period|
      procurement.send("optional_call_off_extensions_#{extenion_period.extension + 1}=", extenion_period.years) if extenion_period.years.positive?
    end

    procurement.optional_call_off_extensions.delete_all
    procurement.save
  end
end
