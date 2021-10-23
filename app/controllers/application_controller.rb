class ApplicationController < ActionController::Base
  before_action :user

  def user
    @user = User.find(session[:id])
  end

  def random_string(length)
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...length).map { o[rand(o.length)] }.join
  end
end
