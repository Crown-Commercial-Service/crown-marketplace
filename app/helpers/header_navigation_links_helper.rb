module HeaderNavigationLinksHelper
  def default_navigation_links
    navigation_links = []

    navigation_links << { link_text: t('header_navigation_links_helper.back_to_start'), link_url: facilities_management_path } unless landing_or_admin_page || not_permitted_page
    navigation_links << sign_out_link(facilities_management_destroy_user_session_path)

    navigation_links.compact
  end

  def facilities_management_navigation_links
    navigation_links = []

    navigation_links << back_to_start_link unless page_does_not_require_back_to_start?
    navigation_links << navigation_link_supplier_and_buyer if not_permitted_page && user_signed_in?
    navigation_links << sign_out_link(facilities_management_destroy_user_session_path)

    navigation_links.compact
  end

  def facilites_management_admin_navigation_links
    navigation_links = []

    navigation_links << { link_text: t('header_navigation_links_helper.admin_dashboard'), link_url: facilities_management_admin_path } if user_signed_in? && request.original_fullpath != facilities_management_admin_path
    navigation_links << sign_out_link(facilities_management_admin_destroy_user_session_path)

    navigation_links.compact
  end

  def facilites_management_supplier_navigation_links
    navigation_links = []

    navigation_links << { link_text: supplier_back_to_start_text, link_url: facilities_management_supplier_path } unless fm_supplier_login_page
    navigation_links << navigation_link_supplier_and_buyer if not_permitted_page && user_signed_in?
    navigation_links << sign_out_link(facilities_management_supplier_destroy_user_session_path)

    navigation_links.compact
  end

  def sign_out_link(sign_out_path)
    { link_text: t('header_navigation_links_helper.sign_out'), link_url: sign_out_path, options: { method: :delete } } if user_signed_in?
  end

  def back_to_start_link
    if page_with_back_to_start?
      { link_text: t('header_navigation_links_helper.back_to_start'), link_url: facilities_management_start_path }
    elsif current_user && !current_user.fm_buyer_details_incomplete?
      { link_text: t('header_navigation_links_helper.my_account'), link_url: facilities_management_path }
    end
  end

  def navigation_link_supplier_and_buyer
    if current_user&.has_role?(:supplier)
      { link_text: t('header_navigation_links_helper.my_dashboard'), link_url: facilities_management_supplier_dashboard_index_path }
    elsif current_user&.has_role?(:buyer)
      { link_text: t('header_navigation_links_helper.my_account'), link_url: facilities_management_path }
    end
  end

  def page_does_not_require_back_to_start?
    landing_or_admin_page || fm_buyer_landing_page || fm_supplier_landing_page || not_permitted_page || fm_landing_page
  end

  def page_with_back_to_start?
    fm_back_to_start_page || cookies_page || fm_activate_account_landing_page || accessibility_statement_page
  end

  def supplier_back_to_start_text
    passwords_page || cookies_page || accessibility_statement_page ? t('header_navigation_links_helper.back_to_start') : t('header_navigation_links_helper.my_dashboard')
  end
end
