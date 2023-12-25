class User < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :concerts, through: :favorites

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.hoarder
    User.find_by(email: "thoarder@example.com")
  end

  def favorite(concert)
    favorites.find_by(concert_id: concert.id)
  end
end
