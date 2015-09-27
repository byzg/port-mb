FactoryGirl.define do
  factory :album, class: Album do 
    association :cover, factory: :photo
  end
end