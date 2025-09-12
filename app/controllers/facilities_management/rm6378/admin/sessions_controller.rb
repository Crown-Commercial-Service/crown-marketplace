module FacilitiesManagement
  module RM6378
    module Admin
      class SessionsController < Base::SessionsController
        include FacilitiesManagement::Admin::FrameworkStatusConcern
      end
    end
  end
end
