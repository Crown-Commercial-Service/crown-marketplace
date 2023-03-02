module FacilitiesManagement
  module RM3830
    module Admin
      class PasswordsController < Base::PasswordsController
        include FacilitiesManagement::Admin::FrameworkStatusConcern
      end
    end
  end
end
