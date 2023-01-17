module CrownMarketplace::ManageUsersHelper
  def add_users_back_link(user, section_name)
    link_params = {
      roles: user.roles,
      service_access: user.service_access,
      email: user.email,
      telephone_number: user.telephone_number
    }

    add_user_crown_marketplace_manage_users_path(section: section_name, **link_params.select { |_, value| value.present? })
  end

  def enabled_disabled_status_tag(enabled)
    if enabled
      [:blue, t('crown_marketplace.manage_users.edit_partials.account_status.options.enabled')]
    else
      [:red, t('crown_marketplace.manage_users.edit_partials.account_status.options.disabled')]
    end
  end

  def verified_unverified_status_tag(verified)
    if verified
      [:blue, t('crown_marketplace.manage_users.edit_partials.email_verified.options.verified.')]
    else
      [:grey, t('crown_marketplace.manage_users.edit_partials.email_verified.options.unverified.')]
    end
  end

  def user_confirmation_status_tag(confirmation_status)
    colour = case confirmation_status
             when 'CONFIRMED'
               :blue
             when 'COMPROMISED'
               :red
             else
               :grey
             end

    [colour, confirmation_status]
  end
end
