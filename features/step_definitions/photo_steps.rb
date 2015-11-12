Пусть(/^есть фото "(.*?)"(?: вложенное в альбом "(.*?)")?$/) do |name, parent_name|
  parent_id = nil
  parent_id = Album.find_by_name(parent_name).id if parent_name
  photo = FactoryGirl.create :photo, name: name, album_id: parent_id
end

Пусть(/^фото "(.*?)" становится вложенным в альбом "(.*?)"$/) do |name, album_name|
  album = Album.find_by_name(album_name)
  Photo.find_by_name(name).update(album: album)
end

Тогда(/^не должно существовать фото "(.*?)"$/) do |names|
  expect(Photo.where(name: names.split).size).to eq 0
end