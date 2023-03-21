module FacilitiesManagement
  module RM6232
    module Admin
      class PasswordsController < Base::PasswordsController
        include FacilitiesManagement::Admin::FrameworkStatusConcern
      end
    end
  end
end
