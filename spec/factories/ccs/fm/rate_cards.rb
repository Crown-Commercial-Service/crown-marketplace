FactoryBot.define do
  factory :ccs_fm_rate_card, class: 'CCS::FM::RateCard' do
    source_file { 'my_rate_card_file.dat' }
    data { {} }
  end
end
