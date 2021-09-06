module FacilitiesManagement
  class SessionsController < Base::SessionsController
    before_action :raise_if_unrecognised_framework
  end
end
