module AlbumPhotoCommon
  def name
    super.presence || "##{id}"
  end
end