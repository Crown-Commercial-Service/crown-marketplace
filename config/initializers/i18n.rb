# add newer versions to this array if the method definition didn't change, otherwise do an if-cascade
if ['1.7.0'].include?(I18n::VERSION)

  module I18n
    module Backend
      class Simple
        # Monkey-patch-in localization debugging.. ( see: http://www.unixgods.org/~tilo/Rails/which_l10n_strings_is_rails_trying_to_lookup.html )
        # Enable with ENV['I18N_DEBUG']=1 on the command line in server startup, or ./config/environments/*.rb file.
        #
        def lookup(locale, key, scope = [], options = {})
          init_translations unless initialized?

          keys = I18n.normalize_keys(locale, key, scope, options[:separator])

          Rails.logger.debug "I18N keys: #{keys}" if ENV['I18N_DEBUG']
          process_keys
        end

        def process_keys
          keys.inject(translations) do |result, inner_key|
            inner_key = inner_key.to_sym
            return nil unless result.is_a?(Hash) && result.key?(inner_key)

            result = result[inner_key]
            result = resolve(locale, inner_key, result, options.merge(scope: nil)) if result.is_a?(Symbol)

            Rails.logger.debug "\t\t => " + result.to_s + "\n" if ENV['I18N_DEBUG'] && (result.class == String)

            result
          end
        end
      end
    end
  end

else
  Rails.Logger.debug '\n--------------------------------------------------------------------------------'
  Rails.Logger.debug "WARNING: you are using version #{I18n::VERSION} of the i18n gem."
  Rails.Logger.debug '         Please double check that your monkey-patch still works!'
  Rails.Logger.debug "         see: '#{__FILE__}'"
  Rails.Logger.debug '         see: http://www.unixgods.org/~tilo/Rails/which_l10n_strings_is_rails_trying_to_lookup.html'
  Rails.Logger.debug '--------------------------------------------------------------------------------\n'
end
