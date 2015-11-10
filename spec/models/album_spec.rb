require 'spec_helper'

describe Album do
  let(:album) { create(:album, name: 'al1') }
  let(:child) { create(:album, name: 'al11', album_id: album.id) }
  let(:photo) { create(:photo) }
  def create_hierarchy
    album
    create(:album, name: 'al2')
    child
    create(:album, name: 'al12', album_id: 1)
    create(:album, name: 'al21', album_id: 2)
    create(:album, name: 'al121', album_id: 4)
    create(:album, name: 'al122', album_id: 4)
  end
  it '.hierarchy' do
    create_hierarchy
    should = [
      {album: {id: 1, name: 'al1', album_id: nil}, deep: 0, deepest: false},
      {album: {id: 3, name: 'al11', album_id: 1}, deep: 1, deepest: true},
      {album: {id: 4, name: 'al12', album_id: 1}, deep: 1, deepest: false},
      {album: {id: 6, name: 'al121', album_id: 4}, deep: 2, deepest: true},
      {album: {id: 7, name: 'al122', album_id: 4}, deep: 2, deepest: true},
      {album: {id: 2, name: 'al2', album_id: nil}, deep: 0, deepest: false},
      {album: {id: 5, name: 'al21', album_id: 2}, deep: 1, deepest: true}]
    expect(Album.hierarchy).to eq should
  end

  context '#check_cover_between_children' do
    
    it 'should be valid when photo in album' do
      photo.update(album_id: album.id)
      album.cover_id = photo.id
      expect(album.valid?).to be true
    end

    it 'should be invalid when photo not in album' do
      album.update(cover_id: photo.id)
      expect(album.errors.messages[:cover].first).to match /between_children/
    end

    it 'should be valid when photo in child of album' do
      photo.update(album_id: child.id)
      album.cover_id = photo.id
      expect(album.valid?).to be true
    end

    it 'should be valid when photo in child of other album' do
      other = create(:album, name: 'al2',)
      other_child = create(:album, name: 'al21', album_id: other.id)
      photo.update(album_id: other_child.id)
      album.update(cover_id: photo.id)
      expect(album.errors.messages[:cover].first).to match /between_children/
    end
    
  end

  context '#children_photos' do
    it 'should return own photo' do
      photo.update(album_id: album.id)
      expect(album.children_photos.pluck(:id)).to include photo.id
    end

    it 'should return child`s photo' do
      photo.update(album_id: child.id)
      expect(album.children_photos.pluck(:id)).to include photo.id
    end
  end

  context '#ancestor_for?' do
    it 'should be correct' do
      create_hierarchy
      expect(album.ancestor_for?(Album.find_by_name('al121'))).to be true
      expect(album.ancestor_for?(Album.find_by_name('al21'))).to be false
    end
  end

end