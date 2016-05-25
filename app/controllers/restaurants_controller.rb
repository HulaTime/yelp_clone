class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.build(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.owned_by?(current_user)
      render 'edit'
    else
      flash[:alert] = 'Error: Can only edit your own restaurant'
      redirect_to restaurants_path
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.owned_by?(current_user)
      @restaurant.update(restaurant_params)
    else
      flash[:alert] = 'Error: Can only edit your own restaurant'
    end
    redirect_to '/restaurants'
  end

  def destroy
    restaurant = Restaurant.find(params[:id])
    if restaurant.owned_by?(current_user)
      restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
    else
      flash[:alert] = 'Error: Can only delete your own restaurant'
    end
    redirect_to '/restaurants'
  end


  def restaurant_params
    params.require(:restaurant).permit(:name, :description)
  end
end
