module BookingsHelper
  def pending_bookings_count_for_host
    return 0 unless current_user&.host?
    
    Booking.joins(:listing)
           .where(listings: { user_id: current_user.id })
           .where(status: 'pending')
           .count
  end
end
