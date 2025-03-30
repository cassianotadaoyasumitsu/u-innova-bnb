class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { guest: "guest", host: "host" }, default: :guest

  has_many :listings, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :booked_listings, through: :bookings, source: :listing

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def host?
    role == "host"
  end

  def guest?
    role == "guest"
  end

  private

  def set_default_role
    self.role ||= :guest
  end

  def password_required?
    new_record? || password.present?
  end
end
