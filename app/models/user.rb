class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  enum :role, { guest: "guest", host: "host" }, default: "guest"

  has_many :listings, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :booked_listings, through: :bookings, source: :listing

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validates :role, presence: true, inclusion: { in: roles.keys }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.password_confirmation = user.password
      user.role = "guest" # Set default role for OAuth users
    end
  rescue ActiveRecord::RecordNotUnique => e
    # Se já existe um usuário com o mesmo email, atualiza o provider e uid
    user = User.find_by(email: auth.info.email)
    user.update(provider: auth.provider, uid: auth.uid)
    user
  end

  def host?
    role == "host"
  end

  def guest?
    role == "guest"
  end

  private

  def password_required?
    return false if provider.present?
    new_record? || password.present?
  end
end
