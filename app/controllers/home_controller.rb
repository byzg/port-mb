class HomeController < ApplicationController

  def index
    @albums = Album.where(parent: nil)
  end

end
