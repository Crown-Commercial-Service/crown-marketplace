class FacilitiesManagement::LongListController < ApplicationController
  require_permission :facilities_management, only: :longList
  def longList

    @supplierCount = 0

  end
end
