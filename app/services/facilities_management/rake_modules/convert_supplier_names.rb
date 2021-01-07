# rubocop:disable Rails/Output
class FacilitiesManagement::RakeModules::ConvertSupplierNames
  def initialize(list)
    @mapping_list = case list
                    when :supplier_name_to_id
                      supplier_name_to_id
                    when :id_to_supplier_name
                      id_to_supplier_name
                    end
  end

  def complete_task
    p 'Updating the rate cards'
    update_rate_cards
    p 'Updating the frozen rate cards'
    update_frozen_rate_cards
  end

  def map_supplier_keys(data)
    data.keys.each do |key|
      data[key] = data[key].transform_keys { |old_key| @mapping_list[old_key] }
    end

    data
  end

  private

  def update_rate_cards
    CCS::FM::RateCard.find_in_batches(batch_size: 50) do |group|
      group.each do |rate_card|
        rate_card.data = map_supplier_keys(rate_card.data)
        rate_card.save
      end
    end
  rescue StandardError => e
    Rollbar.log('error', e)
    puts e.message
  end

  def update_frozen_rate_cards
    CCS::FM::FrozenRateCard.find_in_batches(batch_size: 50) do |group|
      group.each do |frozen_rate_card|
        frozen_rate_card.data = map_supplier_keys(frozen_rate_card.data)
        frozen_rate_card.save
      end
    end
  rescue StandardError => e
    Rollbar.log('error', e)
    puts e.message
  end

  def supplier_name_to_id
    FacilitiesManagement::RakeModules::SupplierData.supplier_data_mapping
  end

  def id_to_supplier_name
    supplier_name_to_id.invert
  end
end
# rubocop:enable Rails/Output
