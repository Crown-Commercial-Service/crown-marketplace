module Steppable
  extend ActiveSupport::Concern
  include ActiveModel::Validations
  extend ActiveModel::Translation

  included do
    include ActiveModel::Model
    include ActiveModel::Attributes
  end

  class_methods do
    def permit_list
      array_params, single_params = attribute_names.partition { |name| attribute_types[name].type == :array }
      single_params.map(&:to_sym) + [array_params.to_h { |name| [name.to_sym, []] }]
    end

    def permitted_keys
      attribute_names.map(&:to_sym)
    end
  end

  def slug
    self.class.name.demodulize.underscore.dasherize
  end

  def template
    ['journey', self.class.name.demodulize.underscore].join('/')
  end

  def next_step_class
    nil
  end

  def final?
    next_step_class.nil?
  end

  def translate_input(key)
    I18n.t(key, scope: 'journey_step')
  end
end
