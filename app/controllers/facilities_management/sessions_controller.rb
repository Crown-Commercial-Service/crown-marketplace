module FacilitiesManagement
  class SessionsController < Base::SessionsController
    before_action :redirect_if_unrecognised_framework

    protected

    def redirect_if_unrecognised_framework
      redirect_to facilities_management_unrecognised_framework_path unless RECOGNISED_FRAMEWORKS.include? params[:framework]
    end

    RECOGNISED_FRAMEWORKS = ['RM3830'].freeze
  end
end
