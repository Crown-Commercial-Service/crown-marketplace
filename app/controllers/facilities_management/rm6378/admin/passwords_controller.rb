module FacilitiesManagement
  module RM6378
    module Admin
      class PasswordsController < Base::PasswordsController
        include FacilitiesManagement::Admin::FrameworkStatusConcern
      end
    end
  end
end
