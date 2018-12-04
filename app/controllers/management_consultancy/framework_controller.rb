module ManagementConsultancy
  class FrameworkController < ::ApplicationController
    require_permission :management_consultancy
  end
end
