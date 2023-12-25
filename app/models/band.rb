class Band < ApplicationRecord
  def genres
    genre_tags.split(",")
  end
end
