require 'rails_helper'

RSpec.describe SupplyTeachers::JobType, type: :model do
  subject(:job_types) { described_class.all }

  let(:first_job_type) { job_types.first }

  it 'loads job_types from CSV' do
    expect(job_types.count).to eq(8)
  end

  it 'populates attributes of first job_type' do
    expect(first_job_type.code).to eq('qt')
    expect(first_job_type.description).to eq('Qualified teacher: non-SEN roles')
  end
end
