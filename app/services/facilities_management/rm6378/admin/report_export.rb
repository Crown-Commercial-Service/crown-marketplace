class FacilitiesManagement::RM6378::Admin::ReportExport < ReportExport
  class << self
    def search_criteria_headers
      ['Reference number', 'Contract name', 'Buyer organisation', 'Buyer organisation address', 'Buyer sector', 'Buyer contact name', 'Buyer contact job title', 'Buyer contact email address', 'Buyer contact telephone number', 'Buyer opted in to be contacted', 'Estimated annual cost', 'Estimated contract start date', 'Estimated contract duration', 'Requirements linked to PFI', 'Services', 'Regions', 'Lot']
    end

    # rubocop:disable Metrics/AbcSize
    def search_criteria_row(procurement)
      [
        procurement.contract_number,
        procurement.contract_name,
        procurement.user.buyer_detail.organisation_name,
        procurement.user.buyer_detail.full_organisation_address,
        procurement.user.buyer_detail.sector_name,
        procurement.user.buyer_detail.full_name,
        procurement.user.buyer_detail.job_title,
        procurement.user.email,
        procurement.user.buyer_detail.telephone_number,
        procurement.contact_opt_in ? I18n.t('yes') : I18n.t('no'),
        format_money(procurement.annual_contract_value),
        format_date(procurement.contract_start_date),
        helpers.pluralize(procurement.estimated_contract_duration, I18n.t('facilities_management.rm6378.procurements.new.year')),
        procurement.private_finance_initiative == 'yes' ? I18n.t('yes') : I18n.t('no'),
        procurement.services.map { |service| "#{service.number} #{service.name}" }.join("\n"),
        procurement.jurisdictions.map { |jurisdiction| "#{jurisdiction.name} (#{jurisdiction.code})" }.join("\n"),
        I18n.t('shared.admin.lot_data.index.supplier_lot_data_summary_list.lot_name', number: procurement.lot.number, name: procurement.lot.name),
      ]
    end
    # rubocop:enable Metrics/AbcSize

    def find_searches(report)
      FacilitiesManagement::RM6378::Procurement.where(framework: report.framework, created_at: (report.start_date..(report.end_date + 1))).includes(:lot, user: :buyer_detail).where.not(user_id: test_user_ids).order(created_at: :desc)
    end

    private

    def format_money(cost)
      helpers.number_to_currency(cost, precision: 2, unit: '£')
    end
  end
end
