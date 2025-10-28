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

  def buyer_detail_page
    @buyer_detail_page ||= BuyerDetail.new
  end

  def home_page
    @home_page ||= Home.new
  end

  def manage_users_page
    @manage_users_page ||= ManageUsers.new
  end

  def procurement_page
    @procurement_page ||= case @framework
                          when 'RM6232'
                            procurement_rm6232_page
                          when 'RM6378'
                            procurement_rm6378_page
                          end
  end

  def procurement_rm6232_page
    @procurement_rm6232_page ||= RM6232::Procurement.new
  end

  def procurement_rm6378_page
    @procurement_rm6378_page ||= RM6378::Procurement.new
  end

  def quick_view_page
    @quick_view_page ||= QuickView.new
  end
end
