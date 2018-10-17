class SearchController < ApplicationController
  def hire_via_agency_question
    @back_path = homepage_path
    @form_path = hire_via_agency_answer_path
  end

  def hire_via_agency_answer
    if params[:hire_via_agency] == 'yes'
      redirect_to nominated_worker_question_path(
        hire_via_agency_params
      )
    elsif params[:hire_via_agency] == 'no'
      redirect_to managed_service_provider_question_path(
        hire_via_agency_params
      )
    else
      redirect_to hire_via_agency_question_path(
        hire_via_agency_params
      ), flash: {
        error: 'Please choose an option'
      }
    end
  end

  def managed_service_provider_question
    @back_path = hire_via_agency_question_path(hire_via_agency_params)
    @form_path = managed_service_provider_answer_path
  end

  def managed_service_provider_answer
    if params[:master_vendor] == 'yes'
      redirect_to master_vendor_managed_service_outcome_path(
        params.permit(:hire_via_agency, :master_vendor)
      )
    elsif params[:master_vendor] == 'no'
      redirect_to neutral_vendor_managed_service_outcome_path(
        params.permit(:hire_via_agency, :master_vendor)
      )
    else
      redirect_to managed_service_provider_question_path(
        params.permit(:hire_via_agency, :master_vendor)
      ), flash: {
        error: 'Please choose an option'
      }
    end
  end

  def nominated_worker_question
    @back_path = hire_via_agency_question_path(hire_via_agency_params)
    @form_path = nominated_worker_answer_path
  end

  def nominated_worker_answer
    if params[:nominated_worker] == 'yes'
      redirect_to school_postcode_question_path(
        params.permit(:nominated_worker, :hire_via_agency)
      )
    elsif params[:nominated_worker] == 'no'
      redirect_to non_nominated_worker_outcome_path(
        params.permit(:nominated_worker, :hire_via_agency)
      )
    else
      redirect_to nominated_worker_question_path(
        params.permit(:nominated_worker, :hire_via_agency)
      ), flash: {
        error: 'Please choose an option'
      }
    end
  end

  def school_postcode_question
    @back_path = nominated_worker_question_path(params.permit(:nominated_worker, :hire_via_agency))
    @form_path = school_postcode_answer_path
  end

  def school_postcode_answer
    redirect_to branches_path(params.permit(:postcode, :nominated_worker, :hire_via_agency))
  end

  def master_vendor_managed_service_outcome
    @back_path = managed_service_provider_question_path(params.permit(:hire_via_agency, :master_vendor))
  end

  def neutral_vendor_managed_service_outcome
    @back_path = managed_service_provider_question_path(params.permit(:hire_via_agency, :master_vendor))
  end

  def non_nominated_worker_outcome
    @back_path = nominated_worker_question_path(params.permit(:nominated_worker, :hire_via_agency))
  end

  private

  def hire_via_agency_params
    params.permit(:hire_via_agency)
  end
end
