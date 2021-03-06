Пусть(/^есть альбом "(.*?)"(?: вложенный в альбом "(.*?)")?$/) do |name, parent_name|
  parent_id = nil
  parent_id = Album.find_by_name(parent_name).id if parent_name
  FactoryGirl.create :album, name: name, album_id: parent_id
end

Тогда(/^не должно существовать альбомов "(.*?)"$/) do |names|
  expect(Album.where(name: names.split).size).to eq 0
end
