module SupplyTeachers
  module Steps
    class FixedTermResults
      include JourneyStep
      include Results

      def rates
        Rate.direct_provision.fixed_term
      end

      def rate(branch)
        branch.supplier.fixed_term_rate
      end
    end
  end
end
