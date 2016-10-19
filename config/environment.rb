DOMAIN = 'muon.me'
ADMINS = [
  {
    email: 'maria.serg91@gmail.com',
    vk_domain: 'muon91'
  },
  {
    email: 'byzg00@gmail.com',
    vk_domain: 'byzgaj'
  }
].map {|admin| OpenStruct.new(admin) }.freeze

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
