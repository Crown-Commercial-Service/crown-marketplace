namespace :procurements do
  namespace :rm3830 do
    desc 'Remove procurements that should have suppliers (contracts), but do not'
    task cleanup: :environment do
      puts 'Removing procurements lacking suppliers (contracts)'

      FacilitiesManagement::RM3830::Procurement
        .includes(:procurement_suppliers)
        .where(aasm_state: %w[results da_draft direct_award further_competition closed]).each do |procurement|
        if procurement.procurement_suppliers.none?
          puts "Deleting procurement with ID #{procurement.id}"
          procurement.destroy
        end
      end
    end
  end
end
