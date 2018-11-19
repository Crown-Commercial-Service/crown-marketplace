require 'rails_helper'

RSpec.describe TempToPermCalculator::HomeController, type: :controller do
  describe 'GET index' do
    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe 'GET fee' do
    def request
      get :fee, params: {
        day_rate: '600',
        days_per_week: '5',
        contract_start_year: '2018',
        contract_start_month: '12',
        contract_start_day: '1',
        hire_date_year: '2018',
        hire_date_month: '12',
        hire_date_day: '10',
        markup_rate: '30',
        school_holidays: '2'
      }
    end

    # rubocop:disable RSpec/ExampleLength
    it 'calls the calculator with the correct parameters' do
      calculator = instance_double('TempToPermCalculator::Calculator')
      allow(calculator).to receive(:fee).and_return(500)
      allow(TempToPermCalculator::Calculator)
        .to receive(:new)
        .and_return(calculator)

      request

      expect(TempToPermCalculator::Calculator).to have_received(:new).with(
        day_rate: 600,
        days_per_week: 5,
        contract_start_date: Date.new(2018, 12, 1),
        hire_date: Date.new(2018, 12, 10),
        markup_rate: 0.30,
        school_holidays: 2
      )
    end
    # rubocop:enable RSpec/ExampleLength

    it 'assigns the calculator to the view' do
      request

      expect(assigns(:calculator)).to be_truthy
    end

    it 'renders the template' do
      request

      expect(response).to render_template(:fee)
    end
  end
end
