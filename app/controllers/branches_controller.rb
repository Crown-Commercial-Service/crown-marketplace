class BranchesController < ApplicationController
  def index
    @branches = Branch.all
  end
end
