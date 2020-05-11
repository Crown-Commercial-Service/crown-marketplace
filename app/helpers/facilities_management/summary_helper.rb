module FacilitiesManagement::SummaryHelper
  def title
    return "You have #{@report.list_of_services.count} services selected" if @current_lot.nil?

    'Shortlist of suppliers'
  end

  def services_and_suppliers_title
    return services_title if @current_lot.nil?

    suppliers_title
  end

  def lot_title
    return if @current_lot.nil?

    str = "<p class='govuk-!-font-size-24'>Based on your requirements, here are the shortlisted suppliers.<br>Your selected sub-lot is <strong>Lot #{@current_lot}
    </strong>, subject to your total contract value and services without a price.</p>"
    str << '<p class="govuk-heading-m">'
    str <<
      case @current_lot
      when '1a'
        'Total contract value up to £7m'
      when '1b'
        'Total contract value between £7m to £50m'
      when '1c'
        'Total contract value over £50m'
      end
    str << '</p>'
  end

  def list_services
    if @current_lot.nil?
      str = '<p class="govuk-!-font-size-24"><strong>Services without pricing</strong><p/>'
      @report.without_pricing.each do |service|
        str << "<p>#{service.name}</p><hr style='width: 50%;margin-left: 0;border-style: dotted;'/>"
      end
    else
      str = "<p><strong>Services with pricing (#{@report.with_pricing.count}):</strong><p/>"
      @report.with_pricing.each do |service|
        str << "<p><strong>#{service.name}</strong></p><hr style='width: 50%;margin-left: 0;border-style: dotted;'/>"
      end
    end
    str
  end

  def list_suppliers
    str = "<p><strong>Lot #{@current_lot}</strong><p/>"

    @report.selected_suppliers(@current_lot).each do |supplier|
      str << "<p>#{supplier.data['supplier_name']}</p><hr style='width: 50%;margin-left: 0;'/>"
    end
    str
  end

  # rubocop:disable Metrics/AbcSize
  def list_choices
    str = '<p class="govuk-heading-m govuk-!-margin-top-4">Choices used to generate your shortlist</p>'
    str << '<details class="govuk-details"><summary class="govuk-details__summary"><span class="govuk-details__summary-text">'
    str << 'Regions (' + @report.subregions.count.to_s + ')</span></summary><div class="govuk-details__text">'
    str << '<ul class="govuk-!-margin-top-0">'
    @report.subregions.each do |location|
      str << '<li>' + location[1] + '</li>'
    end
    str << '</ul></details>'
    services = @report.list_of_services
    services.sort_by!(&:name)
    str << '<details class="govuk-details"><summary class="govuk-details__summary"><span class="govuk-details__summary-text">'
    str << 'Services (' + services.count.to_s + ')</span></summary><div class="govuk-details__text"><ul class="govuk-!-margin-top-0">'
    services.each do |s|
      str << '<li>' + s.name + '</li>'
    end
    str << '</ul></details><hr/>'
    str
  end
  # rubocop:enable Metrics/AbcSize

  def services_title
    count = @report.without_pricing.count

    str = '<strong>However, '
    str <<
      if count == 1
        '1 service does '
      else
        "#{count} services do "
      end
    str << 'not have a price and we need you to estimate these costs'
  end

  def suppliers_title
    str = "<strong>#{@report.selected_suppliers(@current_lot).count} suppliers found</strong>"
    str << ' to provide the chosen services in your regions.'
    str << '<br/>'
    str << 'Your estimated cost is <strong>' + ActiveSupport::NumberHelper.number_to_currency(@report.assessed_value, precision: 0) + "</strong> for the contract term of #{@report.contract_length_years} years."
  end

  def no_price_message
    "Suggested sub-lot <span style='display:inline-block; position: relative; left: 270px;'><strong>Lot #{@report.current_lot}</strong></span>"
  end

  def calculate_uom_value(val)
    uom_value = nil
    if val[:uom_value].is_a? Numeric
      uom_value = val[:uom_value].to_f
    elsif val[:uom_value].is_a? String # rspec cases use string for the value
      uom_value = val[:uom_value].to_f
    elsif val[:uom_value][:monday][:uom].is_a? Numeric
      uom_value = 0
      Date::DAYNAMES.each { |day| uom_value += val[:uom_value][day.downcase.to_sym][:uom] }
      uom_value = (uom_value * 52).round(2) # for each week in the year
    end
    uom_value
  end
end
