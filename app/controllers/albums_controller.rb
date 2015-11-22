class AlbumsController < ApplicationController
  def index
    @albums = Album.where(parent: nil)
  end

  def show
    @albums = current_album.children Album.where(parent: params[:id])
    if @albums.present?
      render :index
    elsif @albums.empty? && Album.deepest.include?(current_album)
      @photos = current_album.photos
      render 'photos/index'
    end    
  end

private
  def current_album
    @current_album ||= Album.find(params[:id])
  end

end