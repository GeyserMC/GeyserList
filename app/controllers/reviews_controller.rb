class ReviewsController < ApplicationController
  def create
    begin
      server = Server.find(params[:server_id])
      user = User.find(session[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:modal_js] = "Failed to leave review: Server or User was nil!"
      redirect_to server_url(params[:server_id])
      return
    end

    review = Review.create(server_id: server.id, user_id: user.id, rating: params['rating'], description: params['review'])
    if review.valid?
      redirect_to "/servers/#{server.id}"
    else
      flash[:modal_js] = review.errors.full_messages.join("<br>")
      flash[:review] = params['review']
      redirect_to "/servers/#{server.id}"
    end
  end

  def update
    begin
      server = Server.find(params[:server_id])
      user = User.find(session[:id])
      review = Review.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:modal_js] = "Failed to leave review: Server or User was nil!"
      redirect_to server_path("/servers/#{params['id']}")
      return
    end

    unless review.user_id == user.id
      flash[:modal_js] = "You do not have permission to edit this review!"
      redirect_to server_url(params[:server_id])
      return
    end

    review.update(rating: params['rating'], description: params['review'])
    if review.valid?
      flash[:modal_js] = "Updated your review!"
    else
      flash[:modal_js] = review.errors.full_messages.join("<br>")
      flash[:review] = params['review']
    end
    redirect_to "/servers/#{server.id}"
  end

  def destroy
    begin
      server = Server.find(params[:server_id])
      user = User.find(session[:id])
      review = Review.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:modal_js] = "Failed to delete review: Server, User, or Review is nil!"
      redirect_to server_url(params[:server_id])
      return
    end

    if review.able_to_delete? user
      review.destroy!
      flash[:modal_js] = "Review deleted successfully!"
    else
      flash[:modal_js] = "You do not have permission to delete this review!"
    end
    redirect_to server_url(params[:server_id])
  end
end