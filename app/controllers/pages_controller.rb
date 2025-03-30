class PagesController < ApplicationController
  def home
    @latest_listings = Listing.order(created_at: :desc).limit(3)
  end
end 