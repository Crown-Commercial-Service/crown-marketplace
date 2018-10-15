class SearchController < ApplicationController
  def nominated_worker_question; end

  def nominated_worker_answer
    if params[:nominated_worker].present?
      if params[:nominated_worker] == 'yes'
        redirect_to school_postcode_question_path
      else
        redirect_to non_nominated_worker_outcome_path
      end
    else
      redirect_to nominated_worker_question_path
    end
  end

  def school_postcode_question; end

  def school_postcode_answer
    redirect_to branches_path(params.permit(:postcode))
  end

  def non_nominated_worker_outcome; end
end
