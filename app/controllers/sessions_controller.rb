require 'soundcloud'

class SessionsController < ApplicationController
  before_filter :set_current_user
  
  def new
    # create client object with app credentials
    client = Soundcloud.new(:client_id => '651bb9d2501269f3a3fd1b17638e1186',
                            :client_secret => 'a60a652797b751dfe2fa8a7b9b2a2c71',
                            :redirect_uri => 'http://localhost:3000/callback')
    
    # TODO: Add try to make sure that the access token is retrieved successfully
    error = params[:error]
    if error
      flash[:notice] = "Error: #{error}"
    else
      # exchange authorization code for access token
      code = params[:code]
      access_token = client.exchange_token(:code => code)
      
      # create client object with access token
      client = Soundcloud.new(:access_token => access_token[:access_token])
      
      # make an authenticated call
      current_user = client.get('/me')
      
      @user = User.find_by_username(current_user.username)
      
      params[:user] = {
        :username => current_user.username,
        :session_token => access_token[:access_token],
      }
      
      if @user
        @user.session_token = params[:user][:session_token]
        @user.save!
      else
        User.create!(params[:user])
      end

      session[:session_token] = params[:user][:session_token]
    end
    
    # TODO: Use a proper homepage
    redirect_to sessions_path
  end
  
  def create
    # create client object with app credentials
    client = Soundcloud.new(:client_id => '651bb9d2501269f3a3fd1b17638e1186',
                            :client_secret => 'a60a652797b751dfe2fa8a7b9b2a2c71',
                            :redirect_uri => 'http://localhost:3000/callback')
    
    # redirect user to authorize URL
    redirect_to client.authorize_url
  end
  
  def destroy
    session[:session_token] = nil
    redirect_to sessions_path
  end
end
