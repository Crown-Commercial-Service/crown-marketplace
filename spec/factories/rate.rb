FactoryBot.define do
  factory :rate do
    supplier
    job_type { 'job-type' }
    mark_up { 0.5 }
  end
end
