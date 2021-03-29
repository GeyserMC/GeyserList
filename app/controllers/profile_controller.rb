class ProfileController < ApplicationController
  def show
    @profile = User.find_by(username: params['username'])

    if @profile.nil?
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", status: 404, :layout => false }
      end
      return
    end

    @me = @profile.id.to_i == session[:id].to_i
  end
end
