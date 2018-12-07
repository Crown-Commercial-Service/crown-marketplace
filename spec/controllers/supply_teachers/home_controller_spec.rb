require 'rails_helper'

RSpec.describe SupplyTeachers::HomeController, type: :controller, auth: true do
  before do
    permit_framework :supply_teachers
  end

  describe 'GET index' do
    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe 'GET temp_to_perm_fee' do
    def request
      get :temp_to_perm_fee, params: {
        looking_for: 'calculate_temp_to_perm_fee',
        day_rate: '600',
        days_per_week: '5',
        contract_start_date_year: '2018',
        contract_start_date_month: '12',
        contract_start_date_day: '1',
        hire_date_year: '2018',
        hire_date_month: '12',
        hire_date_day: '10',
        markup_rate: '30.5',
        holiday_1_start_date_year: '2018',
        holiday_1_start_date_month: '12',
        holiday_1_start_date_day: '2',
        holiday_1_end_date_year: '2018',
        holiday_1_end_date_month: '12',
        holiday_1_end_date_day: '3',
        holiday_2_start_date_year: '2018',
        holiday_2_start_date_month: '12',
        holiday_2_start_date_day: '4',
        holiday_2_end_date_year: '2018',
        holiday_2_end_date_month: '12',
        holiday_2_end_date_day: '5'
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
        markup_rate: 0.305,
        notice_date: nil,
        holiday_1_start_date: Date.new(2018, 12, 2),
        holiday_1_end_date: Date.new(2018, 12, 3),
        holiday_2_start_date: Date.new(2018, 12, 4),
        holiday_2_end_date: Date.new(2018, 12, 5)
      )
    end
    # rubocop:enable RSpec/ExampleLength

    it 'assigns the calculator to the view' do
      request

      expect(assigns(:calculator)).to be_truthy
    end

    it 'renders the template' do
      request

      expect(response).to render_template(:temp_to_perm_fee)
    end
  end
end
