module CcsPatterns
  class FrameworkController < ::ApplicationController
    before_action :authenticate_user!
  end
end
