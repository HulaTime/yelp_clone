class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build_with_user(review_params, current_user)
    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
  end

  def review_params
    a = params.require(:review).permit(:thoughts, :rating)
    # a[:restaurant_id] = params[:restaurant_id]
    # a
  end

  def destroy
    review = Review.find(params[:id])
    review.destroy if review.owned_by?(current_user)
    redirect_to restaurant_path(params[:restaurant_id])
  end

end
