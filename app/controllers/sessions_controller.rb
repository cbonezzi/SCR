require 'soundcloud'

class SessionsController < ApplicationController
  before_filter :set_current_user
  
  def new
    # create client object with app credentials
    client = Soundcloud.new(:client_id => 'd2e2927d267c9beb15ad51ad98e897c6',
                            :client_secret => '701f490a67e92cdeb5433ab7c5d6d7bf',
                            :redirect_uri => 'http://soundcloudradio.herokuapp.com/callback')
    
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
    client = Soundcloud.new(:client_id => 'd2e2927d267c9beb15ad51ad98e897c6',
                            :client_secret => '701f490a67e92cdeb5433ab7c5d6d7bf',
                            :redirect_uri => 'http://soundcloudradio.herokuapp.com/callback')
    
    # redirect user to authorize URL
    redirect_to client.authorize_url
  end
  
  def destroy
    session[:session_token] = nil
    redirect_to sessions_path
  end
end
