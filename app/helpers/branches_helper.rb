module BranchesHelper
  def display_name_for_branch(branch)
    branch.name.present? ? branch.name : branch.town
  end

  def link_to_calculator?
    params[:payroll_provider] != 'school'
  end

  def default_search_range
    "#{SupplyTeachers::Branch::DEFAULT_SEARCH_RANGE_IN_MILES} miles"
  end
end
