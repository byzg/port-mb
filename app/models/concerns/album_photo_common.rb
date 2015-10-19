module AlbumPhotoCommon
  def name
    super.presence || (id ? "##{id}" : '')
  end
end