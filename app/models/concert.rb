class Concert < ApplicationRecord
  belongs_to :venue

  has_many :gigs,
    -> { order(order: :asc) },
    dependent: :destroy,
    inverse_of: :concert

  has_many :bands, through: :gigs
  has_many :tickets, dependent: :destroy

  validates :name, presence: true

  enum ilk: {concert: "concert", meet_n_greet: "meet_n_greet", battle: "battle"}
  enum access: {general: "general", members: "members", vips: "vips"}

  def start_day
    start_time.to_date
  end

  def duration_minutes
    gigs.map(&:duration_minutes).sum
  end

  def genre_parameters
    genre_tags.split(",").map(&:parameterize).join(",")
  end

  def unsold_ticket_count
    tickets.unsold.count
  end

  def sold_out?
    unsold_ticket_count.zero?
  end

  def sell_out!
    tickets.update_all(status: :purchased, user: User.hoarder)
  end

  def find_ticket_at(row:, number:)
    tickets.find { |ticket| ticket.row == row && ticket.number == number }
  end

  def self.random_purchase_all!(min = 10, max = 30)
    Concert.find_each { |concert| concert.random_purchase!(min, max) }
  end

  def random_purchase!(min = 10, max = 30)
    purchase = rand(min..max)

    purchase.times do
      tickets.unsold.sample.update(status: :purchased, user: User.hoarder)
    end
  end
end
