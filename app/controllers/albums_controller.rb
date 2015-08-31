class AlbumsController < ApplicationController

  def index
    @albums = Album.where(parent: nil)
  end

  def show
    @albums = Album.where(parent: params[:id])
  end

end