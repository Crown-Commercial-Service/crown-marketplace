module FacilitiesManagement
  module Beta
    class SummaryController < FrameworkController
      def index
        @start_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
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

      # rubocop:disable Metrics/AbcSize
      def sorted_suppliers
        build_direct_award_report

        return if params[:'download-spreadsheet'] != 'yes'

        # it 'create a direct-award report' do
        user_email = current_user.email.to_s
        start_date = DateTime.now.utc

        report = FacilitiesManagement::SummaryReport.new(start_date, user_email, TransientSessionInfo[session.id])

        selected_buildings = CCS::FM::Building.buildings_for_user(user_email)
        uvals = @report.uom_values(selected_buildings)

        rates = CCS::FM::Rate.read_benchmark_rates
        rate_card = CCS::FM::RateCard.latest

        results = {}
        report_results = {}
        supplier_names = rate_card.data['Prices'].keys
        supplier_names.each do |supplier_name|
          report_results[supplier_name] = {}
          # dummy_supplier_name = 'Hickle-Schinner'
          report.calculate_services_for_buildings selected_buildings, uvals, rates, rate_card, supplier_name, report_results[supplier_name]
          results[supplier_name] = report.direct_award_value
        end

        sorted_list = results.sort_by { |_k, v| v }
        supplier_name = sorted_list.first[0]
        # supplier_da_price = sorted_list.first[1]

        spreadsheet = FacilitiesManagement::DirectAwardSpreadsheet.new supplier_name, report_results[supplier_name]
        render xlsx: spreadsheet.to_xlsx, filename: 'direct_award_prices'
      end
      # rubocop:enable Metrics/AbcSize

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
          # e.g. dummy_supplier_name = 'Hickle-Schinner'
          @report.calculate_services_for_buildings selected_buildings, uvals, rates, rate_card, supplier_name
          @results[supplier_name] = @report.direct_award_value
        end
      end
    end
  end
end
