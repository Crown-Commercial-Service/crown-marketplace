module FacilitiesManagement
  module Beta
    class SummaryController < FrameworkController
      def index
        build_direct_award_report
      end

      def guidance
        # render plain: 'guidance test'

        if params['download-spreadsheet'] == 'yes'
          redirect_to '/facilities-management/summary?calculations=yes&format=xlsx'
        else
          render 'facilities_management/beta/summary/guidance'
        end
      end

      def sorted_suppliers
        build_direct_award_report
      end

      private

      def build_direct_award_report
        user_email = current_user.email.to_s

        @report = SummaryReport.new(@start_date, user_email, TransientSessionInfo[session.id])

        selected_buildings = CCS::FM::Building.buildings_for_user(user_email)

        uvals = @report.uom_values(selected_buildings)

        rates = CCS::FM::Rate.read_benchmark_rates
        rate_card = CCS::FM::RateCard.latest

        @results = {}
        supplier_names = rate_card.data['Prices'].keys
        supplier_names.each do |supplier_name|
          # dummy_supplier_name = 'Hickle-Schinner'
          @report.calculate_services_for_buildings selected_buildings, uvals, rates, rate_card, supplier_name
          @results[supplier_name] = @report.direct_award_value
        end
      end
    end
  end
end
