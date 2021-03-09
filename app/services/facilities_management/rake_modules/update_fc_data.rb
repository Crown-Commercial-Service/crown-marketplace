module FacilitiesManagement::RakeModules::UpdateFCData
  def self.update_fc_data
    FacilitiesManagement::Procurement.further_competition.where(contract_number: nil).find_in_batches do |group|
      group.each do |procurement|
        procurement.contract_number = generate_contract_number_fc(procurement.updated_at.year)
        procurement.contract_datetime = procurement.updated_at.in_time_zone('London').strftime('%d/%m/%Y -%l:%M%P')
        procurement.save
      end
    end
  end

  def self.generate_contract_number_fc(year)
    "RM3830-FC#{unique_number(year)}-#{year}"
  end

  def self.unique_number(year)
    potential_numbers = (1..9999).map { |integer| format('%04d', integer % 10000) }

    (potential_numbers - used_numbers(year)).sample
  end

  def self.used_numbers(year)
    FacilitiesManagement::Procurement.where('contract_number like ?', 'RM3860-FC%')
                                     .where('contract_number like ?', "%-#{year}")
                                     .pluck(:contract_number)
                                     .map { |contract_number| contract_number.split('-')[1].split('FC')[1] }
  end
end
