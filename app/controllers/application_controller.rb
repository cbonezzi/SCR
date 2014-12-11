class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :setup_environment

  def set_current_user
    @current_user ||= session[:session_token] && User.find_by_session_token(session[:session_token])
  end

  def setup_environment
    @env = ENV['RAILS_ENV']
    @sc_api_client_id = SC_CREDENTIALS[@env][:client_id]
    @sc_api_client_secret = SC_CREDENTIALS[@env][:client_secret]
    @sc_api_redirect_uri = SC_CREDENTIALS[@env][:redirect_uri]
    @lfm_api_key = LFM_CREDENTIALS[:key]
  end

  def clear_session
    session[:last_route] = nil
    session[:search_term] = nil
  end

  def save_session
    clear_session
    if request.env['PATH_INFO'] != '/sessions'
      session[:last_route] = request.env['PATH_INFO']
    end
    session[:search_term] ||= params[:search_term]
  end
end
