class ApplicationController < ActionController::Base
  include HttpAuthConcern
  allow_browser versions: :modern
  skip_forgery_protection
end
