FactoryGirl.define do
  factory :photo, class: Photo do 
    image_file_name 'SOMENAME.JPG'
    image_content_type 'image/jpeg'
    image_file_size 4820216
    image_updated_at '2015-09-21 22:10:40'
    description   'Описание1'
  end
end