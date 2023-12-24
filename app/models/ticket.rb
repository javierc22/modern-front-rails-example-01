class Ticket < ApplicationRecord
  enum status: {
    unsold: "unsold",
    held: "held",
    purchased: "purchased",
    refunded: "refunded"
  }
end
