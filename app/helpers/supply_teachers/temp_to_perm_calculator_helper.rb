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
end
