class BranchesController < ApplicationController
  def index
    @back_path = back_path

    if params[:postcode].nil?
      @branches = all_branch_results
    else
      @location = Location.new(params[:postcode])

      unless @location.valid?
        display_error(@location.error)
        return
      end

      @branches = branch_results_near(@location.point)
    end

    respond_to do |format|
      format.html
      format.xlsx do
        spreadsheet = Spreadsheet.new(@branches, with_calculations: params[:calculations].present?)
        render xlsx: spreadsheet.to_xlsx, filename: 'branches'
      end
    end
  end

  private

  def back_path
    if params[:nominated_worker] == 'yes' || params[:school_payroll] == 'yes'
      search_question_path(slug: 'school-postcode', params: safe_params)
    else
      search_question_path(slug: 'agency-payroll', params: safe_params)
    end
  end

  def job_type
    JobType.find_by(code: params[:job_type])
  end

  def term
    Term.find_by(code: params[:term])
  end

  def rates
    if params[:nominated_worker] == 'yes'
      Rate.direct_provision.nominated_worker
    elsif params[:school_payroll] == 'yes'
      Rate.direct_provision.fixed_term
    elsif params[:school_payroll] == 'no'
      Rate.direct_provision.rate_for(job_type: job_type, term: term)
    end
  end

  def branch_results_near(point)
    Branch.search(point, rates: rates).map do |branch|
      search_result_for(branch).tap do |result|
        if params[:nominated_worker] == 'yes'
          result.rate = branch.supplier.nominated_worker_rate
        elsif params[:school_payroll] == 'yes'
          result.rate = branch.supplier.fixed_term_rate
        elsif params[:school_payroll] == 'no'
          result.rate = branch.supplier.rate_for(job_type: job_type, term: term)
        end
        result.distance = point.distance(branch.location)
      end
    end
  end

  def all_branch_results
    Branch.includes(:supplier).all.map do |branch|
      search_result_for(branch)
    end
  end

  def search_result_for(branch)
    BranchSearchResult.new(
      supplier_name: branch.supplier.name,
      name: helpers.display_name_for_branch(branch),
      contact_name: branch.contact_name,
      telephone_number: branch.telephone_number,
      contact_email: branch.contact_email
    )
  end

  def display_error(message)
    path = search_question_path(slug: 'school-postcode', params: safe_params)
    redirect_to path, flash: { error: message }
  end

  def safe_params
    params.permit(
      :postcode, :nominated_worker, :looking_for, :school_payroll, :term,
      :job_type
    )
  end
  helper_method :safe_params
end
