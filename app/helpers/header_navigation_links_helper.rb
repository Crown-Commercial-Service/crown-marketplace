module HeaderNavigationLinksHelper
  def default_navigation_links
    framework = params[:framework] || FacilitiesManagement::Framework.default_framework

    build_navigation_links do |navigation_links|
      navigation_links << { link_text: t('header_navigation_links_helper.back_to_start'), link_url: facilities_management_index_path(framework: framework) } unless not_permitted_page?
      navigation_links << sign_out_link(destroy_user_session_path)
    end
  end

  def facilities_management_navigation_links(framework)
    framework ||= FacilitiesManagement::Framework.default_framework

    build_navigation_links do |navigation_links|
      navigation_links << back_to_start_link(framework) unless page_does_not_require_back_to_start?
      navigation_links << navigation_link_supplier_and_buyer(framework) if not_permitted_page? && user_signed_in?
      navigation_links << sign_out_link("/facilities-management/#{framework}/sign-out")
    end
  end

  def facilites_management_admin_navigation_links(framework)
    framework ||= FacilitiesManagement::Framework.default_framework

    build_navigation_links do |navigation_links|
      navigation_links << { link_text: admin_back_to_start_text, link_url: facilities_management_admin_index_path(framework: framework) } unless sign_in_or_dashboard?('home')
      navigation_links << sign_out_link("/facilities-management/#{framework}/admin/sign-out")
    end
  end

  def facilites_management_supplier_navigation_links(framework)
    framework ||= 'RM3830'

    build_navigation_links do |navigation_links|
      navigation_links << { link_text: supplier_back_to_start_text, link_url: "/facilities-management/#{framework}/supplier" } unless sign_in_or_dashboard?('dashboard')
      navigation_links << navigation_link_supplier_and_buyer if not_permitted_page? && user_signed_in?
      navigation_links << sign_out_link("/facilities-management/#{framework}/supplier/sign-out")
    end
  end

  def crown_marketplace_navigation_links
    build_navigation_links do |navigation_links|
      navigation_links << { link_text: t('header_navigation_links_helper.back_to_start'), link_url: crown_marketplace_path } if user_signed_in? && request.original_fullpath != crown_marketplace_path && request.original_fullpath != crown_marketplace_allow_list_index_path
      navigation_links << sign_out_link(crown_marketplace_destroy_user_session_path)
    end
  end

  def build_navigation_links
    navigation_links = []

    yield(navigation_links)

    navigation_links.compact
  end

  def sign_out_link(sign_out_path)
    { link_text: t('header_navigation_links_helper.sign_out'), link_url: sign_out_path, options: { method: :delete } } if user_signed_in?
  end

  def back_to_start_link(framework)
    if !current_user || page_with_back_to_start?
      { link_text: t('header_navigation_links_helper.back_to_start'), link_url: "/facilities-management/#{framework}/start" }
    elsif !current_user.fm_buyer_details_incomplete?
      { link_text: t('header_navigation_links_helper.my_account'), link_url: facilities_management_index_path(framework) }
    end
  end

  def navigation_link_supplier_and_buyer(framework)
    if current_user&.has_role?(:supplier)
      { link_text: t('header_navigation_links_helper.my_dashboard'), link_url: '/facilities-management/RM3830/supplier/dashboard' }
    elsif current_user&.has_role?(:buyer)
      { link_text: t('header_navigation_links_helper.my_account'), link_url: facilities_management_index_path(framework) }
    end
  end

  def page_does_not_require_back_to_start?
    fm_landing_page? || fm_buyer_account_page? || not_permitted_page?
  end

  def page_with_back_to_start?
    fm_back_to_start_page? || fm_activate_account_landing_page?
  end

  def supplier_back_to_start_text
    passwords_page? || !user_signed_in? ? t('header_navigation_links_helper.back_to_start') : t('header_navigation_links_helper.my_dashboard')
  end

  def admin_back_to_start_text
    passwords_page? || !user_signed_in? ? t('header_navigation_links_helper.back_to_start') : t('header_navigation_links_helper.admin_dashboard')
  end

  def fm_buyer_account_page?
    controller.controller_name == 'buyer_account' && controller.action_name == 'index'
  end

  def fm_landing_page?
    controller.controller_name == 'home' && controller.action_name == 'index'
  end

  def fm_back_to_start_page?
    %w[buyer_account sessions registrations passwords].include? controller.controller_name
  end

  def not_permitted_page?
    controller.action_name == 'not_permitted'
  end

  def fm_activate_account_landing_page?
    controller.controller_name == 'users' && controller.action_name == 'confirm_new'
  end

  def passwords_page?
    controller.controller_name == 'passwords'
  end

  def sign_in_or_dashboard?(dashboard_controller)
    (controller.controller_name == 'sessions' && controller.action_name == 'new') || (controller.controller_name == dashboard_controller && controller.action_name == 'index')
  end
end
