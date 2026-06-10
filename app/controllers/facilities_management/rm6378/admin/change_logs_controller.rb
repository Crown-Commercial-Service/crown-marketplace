module FacilitiesManagement
  module RM6378
    module Admin
      class ChangeLogsController < FacilitiesManagement::Admin::FrameworkController
        include ::Admin::ChangeLogActions
        include SectionsConcern
      end
    end
  end
end
