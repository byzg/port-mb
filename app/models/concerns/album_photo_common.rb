module AlbumPhotoCommon
  def name
    super.presence || (id ? "##{id}" : '')
  end

  private

  def move_forbidden(covered)
    if album_id_changed? && id
      _parent = try(:album) || parent
      if covered.any? {|al| !al.ancestor_for?(_parent)}
        errors.add :base, :forbidden_moving_cover 
      end
    end
  end
end