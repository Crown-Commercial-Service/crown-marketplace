class JourneyStep
  include ActiveModel::Attributes
  include ActiveModel::Model
  include ActiveModel::Validations

  def self.attribute(name)
    params << name
    attr_accessor name
  end

  def self.params
    @params ||= []
  end

  def self.from_params(params)
    new(params.permit(*@params))
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
