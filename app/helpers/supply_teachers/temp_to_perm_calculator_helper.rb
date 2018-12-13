module SupplyTeachers::TempToPermCalculatorHelper
  def display_notice_period_required(calculator)
    t('supply_teachers.home.temp_to_perm_fee.notice_period_required',
      days: calculator.days_notice_required)
  end
end
