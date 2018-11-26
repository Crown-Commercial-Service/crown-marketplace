require 'rails_helper'

RSpec.describe 'supply_teachers/suppliers/_master_vendor.html.erb' do
  let(:supplier) { build(:supplier) }
  let(:job_types_vs_rates) { {} }

  before do
    allow(supplier).to receive(:master_vendor_rates_grouped_by_job_type).and_return(job_types_vs_rates)

    render 'supply_teachers/suppliers/master_vendor', master_vendor: supplier
  end

  it 'displays supplier name' do
    expect(rendered).to have_text(supplier.name)
  end

  context 'when there are three rates for job type' do
    let(:job_types_vs_rates) do
      {
        'qt' => [
          build(:master_vendor_rate, job_type: 'qt', term: 'one_week', mark_up: 0.11),
          build(:master_vendor_rate, job_type: 'qt', term: 'twelve_weeks', mark_up: 0.12),
          build(:master_vendor_rate, job_type: 'qt', term: 'more_than_twelve_weeks', mark_up: 0.13)
        ]
      }
    end

    it 'displays rates for each term' do
      expect(rendered).to have_text(/11\.0%\s/)
      expect(rendered).to have_text(/12\.0%\s/)
      expect(rendered).to have_text(/13\.0%\s/)
    end
  end

  context 'when there are is one rate for job type' do
    let(:job_types_vs_rates) do
      {
        'nominated' => [
          build(:master_vendor_rate, job_type: 'nominated', mark_up: 0.3)
        ]
      }
    end

    it 'displays single rate' do
      expect(rendered).to have_text('30.0%')
    end
  end

  context 'when there are rates for two job types' do
    let(:job_types_vs_rates) do
      {
        'nominated' => [
          build(:master_vendor_rate, job_type: 'nominated', mark_up: 0.3)
        ],
        'fixed_term' => [
          build(:master_vendor_rate, job_type: 'fixed_term', mark_up: 0.4)
        ]
      }
    end

    it 'displays rates for both job types' do
      expect(rendered).to have_text(/A specific person\s+30\.0%/)
      expect(rendered).to have_text(/Employed directly\s+40\.0%/)
    end
  end
end
