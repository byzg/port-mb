Пусть(/^есть альбом "(.*?)"$/) do |name|
  a = FactoryGirl.create :album, name: name
  a.cover.image.
end