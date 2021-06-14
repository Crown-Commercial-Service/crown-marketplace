module HeaderNavigationLinksHelper
  def default_navigation_links
    navigation_links = []

    navigation_links << { link_text: t('header_navigation_links_helper.back_to_start'), link_url: facilities_management_path(framework: params[:framework]) } unless landing_or_admin_page || not_permitted_page
    navigation_links << sign_out_link(default_sign_out_path)

    navigation_links.compact
  end

  def facilities_management_navigation_links
    navigation_links = []

    navigation_links << back_to_start_link unless page_does_not_require_back_to_start?
    navigation_links << navigation_link_supplier_and_buyer if not_permitted_page && user_signed_in?
    navigation_links << sign_out_link(facilities_management_rm3830_destroy_user_session_path)

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

    navigation_links << { link_text: supplier_back_to_start_text, link_url: facilities_management_rm3830_supplier_path } unless fm_supplier_login_page
    navigation_links << navigation_link_supplier_and_buyer if not_permitted_page && user_signed_in?
    navigation_links << sign_out_link(facilities_management_rm3830_supplier_destroy_user_session_path)

    navigation_links.compact
  end

  def crown_marketplace_navigation_links
    navigation_links = []

    navigation_links << { link_text: t('header_navigation_links_helper.back_to_start'), link_url: crown_marketplace_path } if user_signed_in? && request.original_fullpath != crown_marketplace_path && request.original_fullpath != crown_marketplace_allow_list_index_path
    navigation_links << sign_out_link(crown_marketplace_destroy_user_session_path)

    navigation_links.compact
  end

  def sign_out_link(sign_out_path)
    { link_text: t('header_navigation_links_helper.sign_out'), link_url: sign_out_path, options: { method: :delete } } if user_signed_in?
  end

  def back_to_start_link
    if !current_user || page_with_back_to_start?
      { link_text: t('header_navigation_links_helper.back_to_start'), link_url: facilities_management_rm3830_start_path }
    elsif !current_user.fm_buyer_details_incomplete?
      { link_text: t('header_navigation_links_helper.my_account'), link_url: facilities_management_rm3830_path }
    end
  end

  def navigation_link_supplier_and_buyer
    if current_user&.has_role?(:supplier)
      { link_text: t('header_navigation_links_helper.my_dashboard'), link_url: facilities_management_rm3830_supplier_dashboard_index_path }
    elsif current_user&.has_role?(:buyer)
      { link_text: t('header_navigation_links_helper.my_account'), link_url: facilities_management_rm3830_start_path }
    end
  end

  def page_does_not_require_back_to_start?
    landing_or_admin_page || fm_buyer_landing_page || fm_supplier_landing_page || not_permitted_page || fm_landing_page
  end

  def page_with_back_to_start?
    fm_back_to_start_page || fm_activate_account_landing_page
  end

  def supplier_back_to_start_text
    passwords_page || cookies_page || accessibility_statement_page ? t('header_navigation_links_helper.back_to_start') : t('header_navigation_links_helper.my_dashboard')
  end

  def default_sign_out_path
    facilities_management_rm3830_destroy_user_session_path
  end

  def fm_buyer_landing_page
    request.path_info.include? 'buyer-account'
  end

  def fm_supplier_landing_page
    request.path_info.include? 'supplier'
  end

  def landing_or_admin_page
    (PLATFORM_LANDINGPAGES.include?(controller.class.controller_path) && controller.action_name == 'index') || controller.action_name == 'landing_page' || ADMIN_CONTROLLERS.include?(controller.class.module_parent_name.try(:underscore))
  end

  def fm_landing_page
    (FACILITIES_MANAGEMENT_LANDINGPAGES.include?(controller.class.controller_path) && controller.action_name == 'index')
  end

  def fm_back_to_start_page
    [FacilitiesManagement::RM3830::BuyerAccountController, FacilitiesManagement::RM3830::SessionsController, FacilitiesManagement::RM3830::RegistrationsController, FacilitiesManagement::RM3830::PasswordsController].include? controller.class
  end

  def not_permitted_page
    controller.action_name == 'not_permitted'
  end

  def cookies_page
    controller.action_name == 'cookie_policy' || controller.action_name == 'cookie_settings'
  end

  def accessibility_statement_page
    controller.action_name == 'accessibility_statement'
  end

  def fm_activate_account_landing_page
    controller.controller_name == 'users' && controller.action_name == 'confirm_new'
  end

  def passwords_page
    controller.controller_name == 'passwords'
  end

  def fm_supplier_login_page
    controller.controller_name == 'sessions' && controller.action_name == 'new'
  end

  ADMIN_CONTROLLERS = ['supply_teachers/admin', 'management_consultancy/admin', 'legal_services/admin'].freeze
  FACILITIES_MANAGEMENT_LANDINGPAGES = ['facilities_management/rm3830/home'].freeze
  PLATFORM_LANDINGPAGES = ['', 'legal_services/home', 'supply_teachers/home', 'management_consultancy/home'].freeze
end
