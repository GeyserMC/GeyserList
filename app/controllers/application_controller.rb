class ApplicationController < ActionController::Base
  def random_string(length)
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...length).map { o[rand(o.length)] }.join
  end
end
