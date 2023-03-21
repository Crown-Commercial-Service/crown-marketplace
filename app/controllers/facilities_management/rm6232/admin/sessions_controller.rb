module FacilitiesManagement
  module RM6232
    module Admin
      class SessionsController < Base::SessionsController
        include FacilitiesManagement::Admin::FrameworkStatusConcern
      end
    end
  end
end
