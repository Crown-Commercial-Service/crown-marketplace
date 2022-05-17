module FacilitiesManagement
  module RM6232
    class Journey::StartAProcurement
      include Steppable

      def next_step_class
        Journey::StartAProcurement
      end
    end
  end
end
