FactoryBot.define do
  factory :rate do
    supplier
    lot_number { 1 }
    job_type { 'nominated' }
    mark_up { 0.5 }
  end
end
