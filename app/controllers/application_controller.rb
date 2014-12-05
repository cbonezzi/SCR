class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def set_current_user
    @current_user ||= session[:session_token] && User.find_by_session_token(session[:session_token])
  end

  def setup_environment
    @development = (ENV['RAILS_ENV'] == "development")
    @production = (ENV['RAILS_ENV'] == "production")
    
    if @production
      @client_id = '651bb9d2501269f3a3fd1b17638e1186'
      @client_secret = 'a60a652797b751dfe2fa8a7b9b2a2c71'
      @uri = 'http://localhost:3000/callback'
    else
      @client_id = 'd2e2927d267c9beb15ad51ad98e897c6'
      @client_secret = '701f490a67e92cdeb5433ab7c5d6d7bf'
      @uri = 'http://soundcloudradio.herokuapp.com/callback'
    end
  end
end
