require 'openneo/auth/server'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :validate_app!
  
  helper_method :remote_session_for
  
  protected
  
  def after_sign_in_path_for(user)
    if @app && remote_sign_in(user, remote_session_for(@app.key))
      remote_destination_url!
    else
      root_path
    end
  end
  
  def validate_app!
    if app_key_valid?
      @app = Openneo::Auth::Server[params[:app]]
    end
  end
  
  def app_key_valid?
    params[:app] && remote_session_for(params[:app])
  end
  
  def remote_session_for(app_key)
    session[:remote_session] && session[:remote_session][app_key]
  end
  
  def remote_destination_url!
    remote_session = remote_session_for(@app.key)
    session[:remote_session].delete(@app.key)
    "http://#{@app.host}#{remote_session[:path]}"
  end
  
  def remote_sign_in(user, remote_session)
    begin
      @app.remote_sign_in!(user, remote_session)
    rescue Openneo::Auth::Server::RemoteAuthFailed => e
      flash[:alert] = "#{e.message} -- this error is likely our fault and hopefully only temporarily. Please try again in a few minutes. If you still have trouble, please let us know. Thanks!"
      false
    else
      true
    end
  end
end
