class Listing < ApplicationRecord
  belongs_to :user

  validates :title, :description, :price_per_night, presence: true
  validates :price_per_night, numericality: { greater_than: 0 }
  validates :title, length: { minimum: 5, maximum: 100 }
  validates :description, length: { minimum: 20, maximum: 1000 }
  validates :address, presence: true, length: { minimum: 10 }
end
