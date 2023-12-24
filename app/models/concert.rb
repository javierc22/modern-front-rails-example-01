class Concert < ApplicationRecord
  belongs_to :venue

  has_many :gigs,
    -> { order(order: :asc) },
    dependent: :destroy,
    inverse_of: :concert

  has_many :bands, through: :gigs
  has_many :tickets, dependent: :destroy

  enum ilk: {concert: "concert", meet_n_greet: "meet_n_greet", battle: "battle"}
  enum access: {general: "general", members: "members", vips: "vips"}
end
