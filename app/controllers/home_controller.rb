class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:finalize_login]
  
  def finalize_login
    @app = Openneo::Auth::Server[params[:app]]
    remote_session = remote_session_for(@app.key)
    if @app && remote_session
      if remote_sign_in(current_user, remote_session)
        redirect_to remote_destination_url!
      else
        redirect_to root_path
      end
    else
      flash[:alert] = "App \"#{params[:app]}\" not found"
      redirect_to root_path
    end
  end
  
  def index
    if @app
      session[:remote_session] ||= {}
      session[:remote_session][@app.key] = params.slice(:path, :session_id)
      sign_in_params = {:app => @app.key}
    else
      sign_in_params = nil
    end
    if user_signed_in?
      if params[:app] && params[:path] && params[:session_id] &&
        params[:from] == Openneo::Auth::Server.config['id'] &&
        remote_sign_in(current_user, params)
        redirect_to remote_destination_url!
      else
        @apps = Openneo::Auth::Server.apps.values.to_a.sort { |a,b| a.name <=> b.name }
      end
    else
      redirect_to(new_user_session_path(sign_in_params))
    end
  end
  
  protected
  
  def app_key_valid?
    params.has_key?(:app) && params[:path] && params[:session_id]
  end
end
