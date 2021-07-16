FactoryBot.define do
  factory :ccs_fm_rate_card, class: 'FacilitiesManagement::RM3830::RateCard' do
    source_file { 'my_rate_card_file.dat' }
    data { {} }
  end
end
