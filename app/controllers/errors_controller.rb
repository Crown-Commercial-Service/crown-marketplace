class ErrorsController < ApplicationController
  require_permission :none
  layout 'errors'
end
