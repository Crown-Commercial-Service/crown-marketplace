module FacilitiesManagement
  class UsersController < Base::UsersController
    before_action :raise_if_unrecognised_live_framework
  end
end
