module JourneyStep
  extend ActiveSupport::Concern
  include ActiveModel::Attributes
  include ActiveModel::Model
  include ActiveModel::Validations
  extend ActiveModel::Translation

  class_methods do
    def attribute(name, type = nil)
      if type == Array
        array_params << name
      else
        single_params << name
      end
      attr_accessor name
    end

    def permit_list
      single_params + [array_params.map { |k| [k, []] }.to_h]
    end

    def attributes
      single_params + array_params
    end

    def single_params
      @single_params ||= []
    end

    def array_params
      @array_params ||= []
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
