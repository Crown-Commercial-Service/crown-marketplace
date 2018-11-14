require 'temp_to_perm_calculator'

module TempToPermCalculator
  class HomeController < ApplicationController
    def index; end

    def fee
      @calculator = TempToPermCalculator::Calculator.new(
        day_rate: params[:day_rate].to_i,
        days_per_week: params[:days_per_week].to_i,
        contract_start_date: contract_start_date,
        hire_date: hire_date,
        markup_rate: params[:markup_rate].to_i / 100.0,
        school_holidays: params[:school_holidays].to_i
      )
    end

    private

    def contract_start_date
      Date.new(
        params[:contract_start_year].to_i,
        params[:contract_start_month].to_i,
        params[:contract_start_day].to_i
      )
    end

    def hire_date
      Date.new(
        params[:hire_date_year].to_i,
        params[:hire_date_month].to_i,
        params[:hire_date_day].to_i
      )
    end
  end
end
