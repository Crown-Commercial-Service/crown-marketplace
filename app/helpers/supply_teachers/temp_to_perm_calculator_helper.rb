module SupplyTeachers::TempToPermCalculatorHelper
  def display_notice_period_required(calculator)
    t('supply_teachers.home.temp_to_perm_fee.notice_period_required',
      days: calculator.days_notice_required)
  end

  def display_notice_period_given(calculator)
    t('supply_teachers.home.temp_to_perm_fee.notice_period_given',
      days: calculator.days_notice_given,
      notice_date: calculator.notice_date.to_s(:long_with_day),
      hire_date: calculator.hire_date.to_s(:long_with_day))
  end

  def display_chargeable_days_for_lack_of_notice(calculator)
    t('supply_teachers.home.temp_to_perm_fee.lack_of_notice_chargeable_days',
      days: calculator.chargeable_working_days_based_on_lack_of_notice)
  end

  def display_suppliers_daily_fee(calculator)
    t('supply_teachers.home.temp_to_perm_fee.daily_supplier_fee',
      fee: number_to_currency(calculator.daily_supplier_fee),
      markup_rate: number_to_percentage(calculator.markup_rate * 100, precision: 1),
      day_rate: number_to_currency(calculator.day_rate))
  end

  def display_suppliers_pro_rata_daily_fee?(calculator)
    calculator.days_per_week < TempToPermCalculator::Calculator::MAXIMUM_NUMBER_OF_WORKING_DAYS_PER_WEEK
  end

  def display_suppliers_pro_rata_daily_fee(calculator)
    t('supply_teachers.home.temp_to_perm_fee.daily_supplier_fee_pro_rata',
      fee: number_to_currency(calculator.working_day_supplier_fee),
      days_per_week: calculator.days_per_week)
  end

  def display_total_fee(calculator)
    t('supply_teachers.home.temp_to_perm_fee.total_fee',
      fee: number_to_currency(calculator.fee))
  end

  def display_working_days(calculator)
    t('supply_teachers.home.temp_to_perm_fee.working_days',
      days: calculator.working_days,
      contract_start_date: calculator.contract_start_date.to_s(:long_with_day),
      hire_date: calculator.hire_date.to_s(:long_with_day))
  end

  def display_chargeable_days_for_early_hire(calculator)
    t('supply_teachers.home.temp_to_perm_fee.early_hire_chargeable_days',
      days: calculator.chargeable_working_days_based_on_early_hire)
  end

  def display_working_days_required
    t('supply_teachers.home.temp_to_perm_fee.working_days_required')
  end
end
