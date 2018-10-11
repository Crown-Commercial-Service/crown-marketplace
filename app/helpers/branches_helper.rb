module BranchesHelper
  def display_name_for_branch(branch)
    branch.name.present? ? branch.name : branch.town
  end
end
