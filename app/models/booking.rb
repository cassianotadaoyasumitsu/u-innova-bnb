class Booking < ApplicationRecord
  belongs_to :listing
  belongs_to :user

  validates :check_in, :check_out, :total_price, presence: true
  validate :check_out_after_check_in
  validate :no_overlapping_bookings
  validates :status, inclusion: { in: %w[pending confirmed cancelled] }

  before_validation :calculate_total_price

  private

  def check_out_after_check_in
    return if check_in.blank? || check_out.blank?

    if check_out <= check_in
      errors.add(:check_out, "must be after check-in date")
    end
  end

  def no_overlapping_bookings
    return if check_in.blank? || check_out.blank?

    overlapping = Booking.where(listing: listing)
                        .where.not(id: id)
                        .where.not(status: 'cancelled')
                        .where('(check_in <= ? AND check_out >= ?) OR (check_in <= ? AND check_out >= ?)',
                               check_out, check_in, check_in, check_in)

    if overlapping.exists?
      errors.add(:base, "This listing is already booked for these dates")
    end
  end

  def calculate_total_price
    return if check_in.blank? || check_out.blank? || listing.blank?

    nights = (check_out - check_in).to_i / 1.day
    self.total_price = listing.price_per_night * nights
  end
end
