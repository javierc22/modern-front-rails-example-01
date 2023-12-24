class TicketOrder < ApplicationRecord
  belongs_to :concert
  belongs_to :shopping_cart
end
