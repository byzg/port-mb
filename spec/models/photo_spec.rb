require 'spec_helper'

describe Album do
  let(:al1) { create(:album, name: 'al1') }
  let(:al2) { create(:album, name: 'al2') }
  let(:al11) { create(:album, name: 'al11', album_id: al1.id) }
  let(:al12) { create(:album, name: 'al12', album_id: al1.id) }
  let(:al21) { create(:album, name: 'al21', album_id: al2.id) }
  let(:al121) { create(:album, name: 'al121', album_id: al12.id) }
  let(:al122) { create(:album, name: 'al122', album_id: al12.id) }
  let(:photo) { create(:photo) }
  def create_hierarchy
    al11
    al121
    al122
    al21
  end
  before(:each) { create_hierarchy }
  it '#move_forbidden' do
    photo.update(album_id: al122.id)
    al1.update(cover: photo)
    photo.update(album_id: al21.id)
    expect(photo.errors.messages.keys).to include(:album_id)
  end

  context 'before_destroy' do
    it 'destroy forbidden' do
      photo.update(album_id: al122.id)
      al1.update(cover: photo)
      stub_request(:head, /.+/)
      photo.destroy
      expect(Photo.count).to eq 1
    end
  end

end