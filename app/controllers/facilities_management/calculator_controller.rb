require 'json'
require 'fm_calculator/calculator'
require 'facilities_management/fm_supplier_data'
class FacilitiesManagement::CalculatorController < ApplicationController
  require_permission :facilities_management, only: :calculator
  def calculator
    byebug
    @calc = FMCalculator::Calculator.new('G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
    x1 = @calc.sumunitofmeasure('G1', 23000, 125, 'Y', 'Y', 'Y', 'N')
    render json: x1
  end
end
