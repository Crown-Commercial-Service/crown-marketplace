module FacilitiesManagement
  module RM3830
    module Admin
      class SessionsController < Base::SessionsController
        include FacilitiesManagement::Admin::FrameworkStatusConcern
      end
    end
  end
end
