class Ticket < ApplicationRecord
  belongs_to :concert
  belongs_to :user, optional: true
  belongs_to :ticket_order, optional: true
  belongs_to :shopping_cart, optional: true

  enum status: {
    unsold: "unsold",
    held: "held",
    purchased: "purchased",
    refunded: "refunded"
  }

  def toggle_for(user)
    return unless user
    return if self.user && self.user != user
    case status
    when "unsold"
      update(status: "held", user: user)
    when "held"
      update(status: "unsold", user: user)
    end
  end
end
