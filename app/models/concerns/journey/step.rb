module Journey::Step
  extend ActiveSupport::Concern
  include ActiveModel::Validations
  extend ActiveModel::Translation

  included do
    include Virtus.model
  end

  class_methods do
    def permit_list
      array_params, single_params =
        attribute_set.partition { |a| a.type.primitive == Array }
      single_params.map(&:name) + [array_params.map { |a| [a.name, []] }.to_h]
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
