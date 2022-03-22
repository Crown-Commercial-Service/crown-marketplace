module FacilitiesManagement
  class RegistrationsController < Base::RegistrationsController
    before_action :raise_if_unrecognised_live_framework
  end
end
