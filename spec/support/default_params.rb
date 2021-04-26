module DefaultParams
  extend ActiveSupport::Concern

  included do
    let(:default_params) { {} }
    prepend RequestHelpersCustomized
  end

  module RequestHelpersCustomized
    l = lambda do |action, **args|
      args[:params] = default_params.merge(args[:params] || {})
      super(action, **args)
    end

    %w[get post patch put delete].each do |method|
      define_method(method, l)
    end
  end
end
