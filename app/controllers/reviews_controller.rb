class ReviewsController < ApplicationController
  # Handle review creation
  def create
    # Ensure user and server exist, get them too
    begin
      server = Server.find(params[:server_id])
      user = User.find(session[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:modal_js] = "Failed to leave review: Server or User was nil!"
      redirect_to server_url(params[:server_id])
      return
    end

    # Create and validate the review
    review = Review.create(server_id: server.id, user_id: user.id, rating: params['rating'], description: params['review'])
    if review.valid?
      flash[:modal_js] = "Review has been created successfully!"
    else
      flash[:modal_js] = review.errors.full_messages.join("<br>")
      flash[:review] = params['review']
    end
    redirect_to server_url(params[:server_id])
  end

  # Handle review editing
  def update
    # Get the review
    begin
      review = Review.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:modal_js] = "Failed to save changes: review is no longer available."
      redirect_to server_path("/servers/#{params['id']}")
      return
    end

    # Ensure review author and user session match
    unless review.user_id == session[:id]
      flash[:modal_js] = "You do not have permission to edit this review!"
      redirect_to server_url(params[:server_id])
      return
    end

    # Update and validate the review
    review.update(rating: params['rating'], description: params['review'])
    if review.valid?
      flash[:modal_js] = "Updated your review!"
    else
      flash[:modal_js] = review.errors.full_messages.join("<br>")
      flash[:review] = params['review']
    end
    redirect_to server_url(params[:server_id])
  end

  # Handle review deleting
  def destroy
    begin
      user = User.find(session[:id])
      review = Review.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:modal_js] = "Failed to delete review: user or review not found!"
      redirect_to server_url(params[:server_id])
      return
    end

    # Ensure user is able to delete the review, then do so
    if review.able_to_delete? user
      review.destroy!
      flash[:modal_js] = "Review deleted successfully!"
    else
      flash[:modal_js] = "Failed to delete review: you do not have permission to delete this review!"
    end
    redirect_to server_url(params[:server_id])
  end
end