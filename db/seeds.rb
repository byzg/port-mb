# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
unless AdminUser.find_by_email('admin@example.com')
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end
cover = Photo.last || Photo.create(description: 'Описание1')
[
  {name: 'al1', parent: nil},
  {name: 'al11', parent: 'al1'},
  {name: 'al12', parent: 'al1'},
  {name: 'al13', parent: 'al1'},
  {name: 'al111', parent: 'al11'},
  {name: 'al112', parent: 'al11'},
  {name: 'al121', parent: 'al12'}
].each do |params|
  p params
  Album.create!(params.merge({
    cover: cover,
    parent: Album.find_by_name(params[:parent])
  }))
end