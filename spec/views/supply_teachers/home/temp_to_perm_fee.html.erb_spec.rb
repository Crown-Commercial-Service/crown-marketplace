require 'rails_helper'

RSpec.describe 'supply_teachers/home/temp_to_perm_fee.html.erb' do
  let(:contract_start_date) { Date.parse('2018-09-03') }
  let(:day_rate) { 0 }
  let(:markup_rate) { 0 }
  let(:hire_date) { nil }
  let(:notice_date) { nil }

  let(:hiring_within_8_weeks?) { nil }
  let(:hiring_between_9_and_12_weeks?) { nil }
  let(:hiring_after_12_weeks?) { nil }

  let(:notice_date_based_on_hire_date) { nil }
  let(:maximum_fee_for_lack_of_notice) { nil }
  let(:days_notice_required) { nil }
  let(:days_notice_given) { nil }
  let(:enough_notice?) { nil }

  let(:chargeable_working_days_based_on_lack_of_notice) { 0 }
  let(:chargeable_working_days_based_on_early_hire) { nil }
  let(:working_days) { nil }
  let(:daily_supplier_fee) { 0 }
  let(:fee) { 0 }

  let(:i18n_key) { 'supply_teachers.home.temp_to_perm_fee' }

  let(:calculator) do
    options = {
      contract_start_date: contract_start_date,
      day_rate: day_rate,
      markup_rate: markup_rate,
      hire_date: hire_date,
      notice_date: notice_date,
      hiring_within_8_weeks?: hiring_within_8_weeks?,
      hiring_between_9_and_12_weeks?: hiring_between_9_and_12_weeks?,
      hiring_after_12_weeks?: hiring_after_12_weeks?,
      maximum_fee_for_lack_of_notice: maximum_fee_for_lack_of_notice,
      days_notice_required: days_notice_required,
      days_notice_given: days_notice_given,
      enough_notice?: enough_notice?,
      chargeable_working_days_based_on_lack_of_notice: chargeable_working_days_based_on_lack_of_notice,
      chargeable_working_days_based_on_early_hire: chargeable_working_days_based_on_early_hire,
      working_days: working_days,
      daily_supplier_fee: daily_supplier_fee,
      fee: fee,
      days_per_week: 0,
      fee_for_early_hire?: nil,
      fee_for_lack_of_notice?: nil,
      before_national_deal_began?: nil,
      ideal_hire_date: Date.parse('2018-11-26'),
      ideal_notice_date: Date.parse('2018-11-26'),
      notice_period_required?: nil,
      notice_date_based_on_hire_date: notice_date_based_on_hire_date,
    }
    instance_double(TempToPermCalculator::Calculator, options)
  end

  before do
    assign(:calculator, calculator)
  end

  describe 'national deal explanation' do
    let(:paragraph_string) { /before the National Deal was awarded/ }

    context 'when contract start date is before national deal began' do
      before do
        allow(calculator).to receive(:before_national_deal_began?).and_return(true)
        render
      end

      it 'displays explanatory text' do
        expect(rendered).to have_text(paragraph_string)
      end
    end

    context 'when contract start date is after national deal began' do
      before do
        allow(calculator).to receive(:before_national_deal_began?).and_return(false)
        render
      end

      it 'displays explanatory text' do
        expect(rendered).not_to have_text(paragraph_string)
      end
    end
  end

  describe 'irrespective of hire date' do
    it 'explains the circumstances under which a supplier can charge a fee' do
      render
      expect(rendered).to have_text(/supplier can charge you a fee for making a temporary member of staff permanent/)
    end
  end

  context 'when hiring after 12 weeks' do
    let(:hiring_after_12_weeks?) { true }

    context 'and giving enough notice' do
      let(:notice_date) { 'notice-date' }
      let(:enough_notice?) { true }

      it 'displays explanation' do
        render
        expect(rendered).to have_text(I18n.t("#{i18n_key}.after_12_weeks_and_enough_notice"))
      end

      it 'does not explain how to avoid paying fees' do
        expect(rendered).not_to render_template('_avoid_paying_fees')
      end
    end

    context 'and not giving enough notice' do
      let(:notice_date) { Date.parse('2018-11-19') }
      let(:hire_date) { Date.parse('2018-11-26') }
      let(:enough_notice?) { false }
      let(:fee) { 50 }
      let(:days_notice_required) { 20 }
      let(:days_notice_given) { 15 }
      let(:chargeable_working_days_based_on_lack_of_notice) { 5 }
      let(:daily_supplier_fee) { 10 }
      let(:markup_rate) { 0.1 }
      let(:day_rate) { 110 }

      before do
        render
      end

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.after_12_weeks_and_not_enough_notice", fee: '£50.00')
        )
      end

      it 'displays notice period required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_required", days: days_notice_required)
        )
      end

      it 'displays notice period given' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_given",
                 days: 15,
                 notice_date: 'Monday 19 November 2018',
                 hire_date: 'Monday 26 November 2018')
        )
      end

      it 'displays chargeable days for lack of notice' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.lack_of_notice_chargeable_days", days: chargeable_working_days_based_on_lack_of_notice)
        )
      end

      it 'displays supplier daily fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
        )
      end

      it 'displays total fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.total_fee", fee: '£50.00')
        )
      end

      it 'explains how to avoid paying fees' do
        expect(rendered).to render_template('_avoid_paying_fees')
      end
    end

    context 'and not entering a notice date' do
      let(:notice_date) { nil }
      let(:maximum_fee_for_lack_of_notice) { 200 }
      let(:days_notice_required) { 20 }
      let(:markup_rate) { 0.1 }
      let(:day_rate) { 110 }
      let(:daily_supplier_fee) { 10 }
      let(:fee) { 50 }
      let(:notice_date_based_on_hire_date) { Date.parse('2018-10-29') }

      before do
        render
      end

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.after_12_weeks_and_no_notice_date",
                 max_fee: '£200.00',
                 latest_notice_date: 'Monday 29 October 2018')
        )
      end

      it 'explains how to avoid paying fees' do
        expect(rendered).to render_template('_avoid_paying_fees')
      end
    end
  end

  context 'when hiring between 9 and 12 weeks' do
    let(:hiring_between_9_and_12_weeks?) { true }

    before do
      render
    end

    context 'and giving enough notice' do
      let(:hire_date) { Date.parse('2018-11-12') }
      let(:notice_date) { 'notice-date' }
      let(:enough_notice?) { true }
      let(:working_days) { 50 }
      let(:chargeable_working_days_based_on_early_hire) { 10 }
      let(:daily_supplier_fee) { 10 }
      let(:markup_rate) { 0.1 }
      let(:day_rate) { 110 }
      let(:fee) { 100 }

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.between_9_and_12_weeks_and_enough_notice")
        )
      end

      it 'displays the number of working days required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days_required")
        )
      end

      it 'displays the number of working days between contract start and hire date' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days",
                 days: 50,
                 contract_start_date: 'Monday 03 September 2018',
                 hire_date: 'Monday 12 November 2018')
        )
      end

      it 'displays the days chargeable for early-hire' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.early_hire_chargeable_days", days: 10)
        )
      end

      it 'displays supplier daily fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
        )
      end

      it 'displays total fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.total_fee", fee: '£100.00')
        )
      end

      it 'explains how to avoid paying fees' do
        expect(rendered).to render_template('_avoid_paying_fees')
      end
    end

    context 'and not giving enough notice' do
      let(:notice_date) { Date.parse('2018-11-19') }
      let(:hire_date) { Date.parse('2018-11-26') }
      let(:enough_notice?) { false }
      let(:working_days) { 50 }
      let(:chargeable_working_days_based_on_early_hire) { 10 }
      let(:days_notice_required) { 20 }
      let(:days_notice_given) { 15 }
      let(:chargeable_working_days_based_on_lack_of_notice) { 5 }
      let(:daily_supplier_fee) { 10 }
      let(:markup_rate) { 0.1 }
      let(:day_rate) { 110 }
      let(:fee) { 150 }

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.between_9_and_12_weeks_and_not_enough_notice")
        )
      end

      it 'displays the number of working days required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days_required")
        )
      end

      it 'displays the number of working days between contract start and hire date' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days",
                 days: 50,
                 contract_start_date: 'Monday 03 September 2018',
                 hire_date: 'Monday 26 November 2018')
        )
      end

      it 'displays the days chargeable for early-hire' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.early_hire_chargeable_days", days: 10)
        )
      end

      it 'displays notice period required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_required", days: 20)
        )
      end

      it 'displays notice period given' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_given",
                 days: 15,
                 notice_date: 'Monday 19 November 2018',
                 hire_date: 'Monday 26 November 2018')
        )
      end

      it 'displays chargeable days for lack of notice' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.lack_of_notice_chargeable_days", days: 5)
        )
      end

      it 'displays supplier daily fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
        )
      end

      it 'displays total fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.total_fee", fee: '£150.00')
        )
      end

      it 'explains how to avoid paying fees' do
        expect(rendered).to render_template('_avoid_paying_fees')
      end
    end

    context 'and not entering a notice date' do
      let(:hire_date) { Date.parse('2018-11-26') }
      let(:maximum_fee_for_lack_of_notice) { 200 }
      let(:notice_date) { nil }
      let(:working_days) { 50 }
      let(:chargeable_working_days_based_on_early_hire) { 10 }
      let(:daily_supplier_fee) { 10 }
      let(:markup_rate) { 0.1 }
      let(:day_rate) { 110 }
      let(:fee) { 100 }
      let(:notice_date_based_on_hire_date) { Date.parse('2018-10-29') }

      it 'displays explanation' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.between_9_and_12_weeks_and_no_notice_date")
        )
      end

      it 'displays the number of working days required' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days_required")
        )
      end

      it 'displays the number of working days between contract start and hire date' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.working_days",
                 days: 50,
                 contract_start_date: 'Monday 03 September 2018',
                 hire_date: 'Monday 26 November 2018')
        )
      end

      it 'displays the days chargeable for early-hire' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.early_hire_chargeable_days", days: 10)
        )
      end

      it 'displays supplier daily fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
        )
      end

      it 'displays total fee' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.total_fee", fee: '£100.00')
        )
      end

      it 'displays disclaimer about not giving enough notice' do
        expect(rendered).to have_text(
          I18n.t("#{i18n_key}.notice_period_disclaimer",
                 max_fee: '£200.00',
                 latest_notice_date: 'Monday 29 October 2018')
        )
      end

      it 'explains how to avoid paying fees' do
        expect(rendered).to render_template('_avoid_paying_fees')
      end
    end
  end

  context 'when hiring within the first 8 weeks' do
    let(:hire_date) { Date.parse('2018-11-26') }
    let(:hiring_within_8_weeks?) { true }
    let(:working_days) { 50 }
    let(:chargeable_working_days_based_on_early_hire) { 10 }
    let(:daily_supplier_fee) { 10 }
    let(:markup_rate) { 0.1 }
    let(:day_rate) { 110 }
    let(:fee) { 100 }

    before do
      render
    end

    it 'displays explanation' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.within_first_8_weeks")
      )
    end

    it 'displays the number of working days required' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.working_days_required")
      )
    end

    it 'displays the number of working days between contract start and hire date' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.working_days",
               days: 50,
               contract_start_date: 'Monday 03 September 2018',
               hire_date: 'Monday 26 November 2018')
      )
    end

    it 'displays the days chargeable for early-hire' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.early_hire_chargeable_days", days: 10)
      )
    end

    it 'displays supplier daily fee' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.daily_supplier_fee", fee: '£10.00', markup_rate: '10.0%', day_rate: '£110.00')
      )
    end

    it 'displays total fee' do
      expect(rendered).to have_text(
        I18n.t("#{i18n_key}.total_fee", fee: '£100.00')
      )
    end

    it 'explains how to avoid paying fees' do
      expect(rendered).to render_template('_avoid_paying_fees')
    end
  end
end
