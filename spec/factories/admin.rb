FactoryGirl.define do
  factory :admin, class: AdminUser do
    email                           'admin@example.com'
    password                        'qwer4321'
    password_confirmation           'qwer4321'
  end

end