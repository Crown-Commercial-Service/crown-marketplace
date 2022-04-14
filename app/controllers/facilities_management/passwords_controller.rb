module FacilitiesManagement
  class PasswordsController < Base::PasswordsController
    before_action :raise_if_unrecognised_live_framework
  end
end
