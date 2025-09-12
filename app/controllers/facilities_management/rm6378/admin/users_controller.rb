module FacilitiesManagement
  module RM6378
    module Admin
      class UsersController < Base::UsersController
        include FacilitiesManagement::Admin::FrameworkStatusConcern
      end
    end
  end
end
