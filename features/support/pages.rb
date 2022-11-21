module Pages
  def allow_list_page
    @allow_list_page ||= AllowList.new
  end

  def admin_page
    @admin_page ||= case @framework
                    when 'RM3830'
                      admin_rm3830_page
                    when 'RM6232'
                      admin_rm6232_page
                    end
  end

  def admin_rm3830_page
    @admin_rm3830_page ||= RM3830::Admin.new
  end

  def admin_rm6232_page
    @admin_rm6232_page ||= RM6232::Admin.new
  end

  def building_page
    @building_page ||= Building.new
  end

  def buyer_detail_page
    @buyer_detail_page ||= BuyerDetail.new
  end

  def contract_page
    @contract_page ||= RM3830::Contract.new
  end

  def contract_detail_page
    @contract_detail_page ||= RM3830::ContractDetail.new
  end

  def entering_requirements_page
    @entering_requirements_page ||= case @framework
                                    when 'RM3830'
                                      entering_requirements_rm3830_page
                                    when 'RM6232'
                                      entering_requirements_rm6232_page
                                    end
  end

  def entering_requirements_rm3830_page
    @entering_requirements_rm3830_page ||= RM3830::EnteringRequirements.new
  end

  def entering_requirements_rm6232_page
    @entering_requirements_rm6232_page ||= RM6232::EnteringRequirements.new
  end

  def home_page
    @home_page ||= RM3830::Home.new
  end

  def manage_users_page
    @manage_users_page ||= ManageUsers.new
  end

  def procurement_page
    @procurement_page ||= case @framework
                          when 'RM3830'
                            procurement_rm3830_page
                          when 'RM6232'
                            procurement_rm6232_page
                          end
  end

  def procurement_rm3830_page
    @procurement_rm3830_page ||= RM3830::Procurement.new
  end

  def procurement_rm6232_page
    @procurement_rm6232_page ||= RM6232::Procurement.new
  end

  def quick_view_page
    @quick_view_page ||= case @framework
                         when 'RM3830'
                           quick_view_rm3830_page
                         when 'RM6232'
                           quick_view_rm6232_page
                         end
  end

  def quick_view_rm3830_page
    @quick_view_rm3830_page ||= RM3830::QuickView.new
  end

  def quick_view_rm6232_page
    @quick_view_rm6232_page ||= RM6232::QuickView.new
  end

  def service_requirement_page
    @service_requirement_page ||= RM3830::ServiceRequirement.new
  end

  def supplier_page
    @supplier_page ||= RM3830::Supplier.new
  end
end
