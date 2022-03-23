module FacilitiesManagement
  class SessionsController < Base::SessionsController
    before_action :raise_if_unrecognised_live_framework
  end
end
