class AvatarsController < ApplicationController
  def show
    @user = User.find params[:user_id]
    options = params.slice(:size, :default)
    redirect_to @user.gravatar_url(options)
  end
end

