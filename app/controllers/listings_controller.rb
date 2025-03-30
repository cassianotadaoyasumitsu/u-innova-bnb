class ListingsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :ensure_host!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner!, only: [:edit, :update, :destroy]

  def index
    @listings = Listing.all
  end

  def show
  end

  def new
    @listing = current_user.listings.build
  end

  def create
    @listing = current_user.listings.build(listing_params)
    
    if @listing.save
      redirect_to @listing, notice: 'Listing was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      redirect_to @listing, notice: 'Listing was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @listing.destroy
    redirect_to listings_url, notice: 'Listing was successfully deleted.'
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :address, :price_per_night, images: [])
  end

  def ensure_host!
    unless current_user.host?
      redirect_to root_path, alert: "Only hosts can manage listings"
    end
  end

  def ensure_owner!
    unless @listing.user == current_user
      redirect_to root_path, alert: "You can only manage your own listings"
    end
  end
end
