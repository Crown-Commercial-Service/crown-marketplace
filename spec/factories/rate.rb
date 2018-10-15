FactoryBot.define do
  factory :rate do
    supplier
    job_type { 'nominated' }
    mark_up { 0.5 }
  end
end
