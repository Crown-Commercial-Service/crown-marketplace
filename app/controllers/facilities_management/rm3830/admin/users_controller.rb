module FacilitiesManagement
  module RM3830
    module Admin
      class UsersController < Base::UsersController
        include FacilitiesManagement::Admin::FrameworkStatusConcern
      end
    end
  end
end
