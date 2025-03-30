class PagesController < ApplicationController
  def home
    @listings = Listing.all

    # Search by title, description, or address
    if params[:query].present?
      @listings = @listings.where("title ILIKE :query OR description ILIKE :query OR address ILIKE :query", 
                                 query: "%#{params[:query]}%")
    end

    # Filter by price range
    if params[:min_price].present?
      @listings = @listings.where("price_per_night >= ?", params[:min_price])
    end
    if params[:max_price].present?
      @listings = @listings.where("price_per_night <= ?", params[:max_price])
    end

    # Sort by price or date
    case params[:sort]
    when "price_asc"
      @listings = @listings.order(price_per_night: :asc)
    when "price_desc"
      @listings = @listings.order(price_per_night: :desc)
    when "date_desc"
      @listings = @listings.order(created_at: :desc)
    else
      @listings = @listings.order(created_at: :desc)
    end

    @latest_listings = @listings.limit(3)
  end
end 