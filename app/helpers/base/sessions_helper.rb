module Base::SessionsHelper
  def local_header_text
    @local_header_text ||= case params[:service]
                           when 'crown_marketplace'
                             t('base.sessions.new.heading.crown_marketplace')
                           when 'facilities_management/admin'
                             t("base.sessions.new.heading.admin.#{params[:framework]}")
                           else
                             t('base.sessions.new.heading.sign_in')
                           end
  end

  def local_email_hint_text
    params[:service] == 'facilities_management' ? t('base.sessions.new.email_hint.set_up') : t('base.sessions.new.email_hint.register')
  end

  def service_has_registration?
    params[:service] == 'facilities_management'
  end
end
