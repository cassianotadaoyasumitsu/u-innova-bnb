class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { guest: "guest", host: "host" }, default: :guest

  has_many :listings, dependent: :destroy

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
end
