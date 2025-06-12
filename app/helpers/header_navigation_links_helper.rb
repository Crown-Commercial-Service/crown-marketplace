# rubocop:disable Metrics/ModuleLength
module HeaderNavigationLinksHelper
  def service_name_text
    case params[:service]
    when 'crown_marketplace'
      t('home.index.crown_marketplace_link')
    when 'facilities_management/admin'
      t('home.index.facilities_management_admin_link')
    when 'facilities_management/supplier'
      t('home.index.facilities_management_supplier_link')
    else
      t('home.index.facilities_management_link')
    end
  end

  def service_authentication_links
    navigation_links = []

    if user_signed_in?
      navigation_links << {
        text: t('header_navigation_links_helper.sign_out'),
        href: "#{service_path_base}/sign-out",
        method: :delete
      }
    else
      if params[:service] == 'facilities_management'
        navigation_links << {
          text: t('header_navigation_links_helper.sign_up'),
          href: "#{service_path_base}/sign-up"
        }
      end

      navigation_links << {
        text: t('header_navigation_links_helper.sign_in'),
        href: "#{service_path_base}/sign-in"
      }
    end

    navigation_links
  end

  def service_navigation_links
    navigation_links = []

    navigation_links << case params[:service]
                        when 'crown_marketplace'
                          crown_marketplace_navigation_link
                        when 'facilities_management/admin'
                          facilites_management_admin_navigation_link
                        when 'facilities_management/supplier'
                          facilites_management_supplier_navigation_link
                        else
                          facilities_management_navigation_link
                        end

    navigation_links.compact
  end

  def crown_marketplace_navigation_link
    { text: crown_marketplace_back_to_start_text, href: crown_marketplace_path } unless sign_in_or_dashboard?('home')
  end

  def facilites_management_admin_navigation_link
    { text: admin_back_to_start_text, href: service_path_base } unless sign_in_or_dashboard?('home')
  end

  def facilites_management_supplier_navigation_link
    { text: supplier_back_to_start_text, href: service_path_base } unless sign_in_or_dashboard?('dashboard')
  end

  def facilities_management_navigation_link
    return back_to_start_link unless page_does_not_require_back_to_start?

    { text: t('header_navigation_links_helper.my_account'), href: service_path_base } if not_permitted_page? && user_signed_in?
  end

  def back_to_start_link
    if !current_user || page_with_back_to_start?
      { text: t('header_navigation_links_helper.back_to_start'), href: "#{service_path_base}/start" }
    elsif !current_user.fm_buyer_details_incomplete?
      { text: t('header_navigation_links_helper.my_account'), href: service_path_base }
    end
  end

  def page_does_not_require_back_to_start?
    fm_landing_page? || fm_buyer_account_page? || not_permitted_page?
  end

  def page_with_back_to_start?
    fm_back_to_start_page? || fm_activate_account_landing_page?
  end

  def crown_marketplace_back_to_start_text
    back_to_start_text(t('header_navigation_links_helper.crown_marketplace'))
  end

  def supplier_back_to_start_text
    back_to_start_text(t('header_navigation_links_helper.my_dashboard'))
  end

  def admin_back_to_start_text
    back_to_start_text(t('header_navigation_links_helper.admin_dashboard'))
  end

  def back_to_start_text(default_text)
    passwords_page? || !user_signed_in? ? t('header_navigation_links_helper.back_to_start') : default_text
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
# rubocop:enable Metrics/ModuleLength
