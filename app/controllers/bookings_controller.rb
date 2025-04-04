class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_listing, only: [:new, :create]
  before_action :ensure_host!, only: [:host_index]

  def index
    @bookings = current_user.bookings.includes(:listing)
  end

  def host_index
    @bookings = Booking.joins(:listing)
                      .where(listings: { user_id: current_user.id })
                      .includes(:listing, :user)
                      .order(created_at: :desc)
  end

  def show
    authorize_booking
  end

  def new
    @booking = @listing.bookings.build
  end

  def create
    @booking = @listing.bookings.build(booking_params)
    @booking.user = current_user

    if @booking.save
      redirect_to @booking, notice: 'Booking was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_booking
  end

  def update
    authorize_booking
    if @booking.update(booking_params)
      redirect_to @booking, notice: 'Booking was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_booking
    @booking.destroy
    redirect_to bookings_url, notice: 'Booking was successfully cancelled.'
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def booking_params
    params.require(:booking).permit(:check_in, :check_out, :status)
  end

  def authorize_booking
    unless @booking.user == current_user || @booking.listing.user == current_user
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def ensure_host!
    unless current_user.host?
      redirect_to root_path, alert: 'You must be a host to access this page.'
    end
  end
end
