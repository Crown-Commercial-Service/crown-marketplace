module I18nOrganisationName
  # Methods used for the CCS transition to GCA

  def translate(key, **options)
    options[:org_name] ||= CurrentOrganisation.current_organisation_name
    options[:org_name_abbr] ||= CurrentOrganisation.current_organisation_name_abbr
    options[:org_domain] ||= CurrentOrganisation.current_organisation_domain

    super
  end

  alias_method :t, :translate
end

I18n.singleton_class.prepend(I18nOrganisationName)
