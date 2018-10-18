require 'rails_helper'

RSpec.describe 'branches/index.html.erb' do
  let(:first_supplier) { build(:supplier, name: 'First Supplier') }
  let(:second_supplier) { build(:supplier, name: 'Second Supplier') }

  let(:first_branch) do
    build(:branch_search_result, name: 'First Branch', supplier_name: 'First Supplier')
  end
  let(:second_branch) do
    build(:branch_search_result, supplier_name: first_supplier.name, name: 'Second Branch')
  end
  let(:third_branch) do
    build(:branch_search_result, supplier_name: second_supplier.name, name: 'Third Branch')
  end

  let(:nominated_worker_rate) { nil }

  let(:branches) { [first_branch, second_branch, third_branch] }
  let(:location) { nil }
  let(:link_to_calculator) { true }

  before do
    assign(:branches, branches)
    assign(:location, location)
    controller.singleton_class.class_eval do
      protected

      def safe_params
        params.permit!
      end
      helper_method :safe_params
    end
    allow(first_supplier).to receive(:nominated_worker_rate).and_return(nominated_worker_rate)
    allow(second_supplier).to receive(:nominated_worker_rate).and_return(nominated_worker_rate)
    allow(view).to receive(:link_to_calculator?).and_return(link_to_calculator)

    render
  end

  it 'displays headings for suppliers for each branch' do
    expect(rendered).to have_css('h2.govuk-heading-m', text: /First Supplier/, count: 2)
    expect(rendered).to have_css('h2.govuk-heading-m', text: /Second Supplier/)
  end

  it 'displays list of all branches' do
    expect(rendered).to have_content('First Branch')
    expect(rendered).to have_content('Second Branch')
    expect(rendered).to have_content('Third Branch')
  end

  it 'displays number of results' do
    expect(rendered).to have_content('3 results found')
  end

  it 'has a link to print the page' do
    expect(rendered).to have_link('Print this page')
  end

  it 'has a link to download a spreadsheet' do
    expect(rendered).to have_link('Download shortlist of suppliers')
  end

  it 'has a link to download the calculator' do
    expect(rendered).to have_link('Download shortlist (with markup calculator)')
  end

  context 'when shortlisting for teachers on school payroll' do
    let(:link_to_calculator) { false }

    it 'does not have a link to download the calculator' do
      expect(rendered).not_to have_link('Download shortlist (with markup calculator)')
    end
  end

  context 'when displaying branches near the buyers location' do
    let(:point) { instance_double('RGeo::Geographic::SphericalPointImpl', distance: 1) }
    let(:location) { instance_double('Location', postcode: 'W1A 1AA', point: point) }
    let(:rates) { [build(:rate, job_type: 'nominated')] }
    let(:nominated_worker_rate) { 1 }

    it 'adds location context to the number of results' do
      expect(rendered).to have_content('3 results found within 25 miles of W1A 1AA')
    end
  end
end
