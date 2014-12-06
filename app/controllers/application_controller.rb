class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :setup_environment

  def set_current_user
    @current_user ||= session[:session_token] && User.find_by_session_token(session[:session_token])
  end

  def setup_environment
    @env = ENV['RAILS_ENV']
    @api_client_id = CREDENTIALS[@env][:client_id]
    @api_client_secret = CREDENTIALS[@env][:client_secret]
    @api_redirect_uri = CREDENTIALS[@env][:redirect_uri]
  end
end
