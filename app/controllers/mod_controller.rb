# Collection of methods and views related to moderating the site
class ModController < ApplicationController
  # Middleware method to ensure user is here and has perms
  before_action :verify_perms

  def verify_perms
    # Verify the user exists and that they are a moderator
    # Simulate a 404 if they aren't authorized
    if @user.nil? || !@user.moderator?
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", status: 404, :layout => false }
      end
    end
  end

  def index

  end

  def users
    @users = User.all
  end

  def reports
    @reports = Report.open_reports
  end
end
