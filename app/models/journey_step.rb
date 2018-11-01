class JourneyStep
  include ActiveModel::Attributes
  include ActiveModel::Model
  include ActiveModel::Validations
  extend ActiveModel::Translation

  def self.attribute(name, type = nil)
    if type == Array
      array_params << name
    else
      single_params << name
    end
    attr_accessor name
  end

  def self.params
    single_params + [array_params.map { |k| [k, []] }.to_h]
  end

  def self.single_params
    @single_params ||= []
  end

  def self.array_params
    @array_params ||= []
  end

  def self.from_params(raw)
    new(raw.permit(*params))
  end

  def slug
    self.class.name.demodulize.underscore.dasherize
  end

  def template
    self.class.name.demodulize.underscore
  end

  def next_step_class
    nil
  end

  def final?
    next_step_class.nil?
  end
end
