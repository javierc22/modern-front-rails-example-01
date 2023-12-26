#---
# Excerpted from "Modern Front-End Development for Rails, Second Edition",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/nrclient2 for more book information.
#---
class FavoritesController < ApplicationController
  def index
  end

  def create
    Favorite.create(user: current_user, concert_id: params[:concert_id])
    render(partial: "favorites/list")
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    render(partial: "favorites/list")
  end

  private def favorite_params
    params.require(:concert_id)
  end
end
