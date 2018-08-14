class User < ApplicationRecord
  include Clearance::User
  # enum role: ["Member","Host","Admin"]

  # sean = User.find(1)
  # sean.Admin! ---> is set sean to admin
  # sean.Admin? --> is it admin?? 
  # enum better use --> interger

  has_many :authentications, dependent: :destroy
  has_many :listings, dependent: :destroy
  mount_uploader :avatar, AvatarUploader

  
 def self.create_with_auth_and_hash(authentication, auth_hash)
   user = self.create!(
     first_name: auth_hash["info"]["first_name"],
     last_name: auth_hash["info"]["last_name"],
     email: auth_hash["info"]["email"],
     birthdate: Date.new,
     password: SecureRandom.hex(10)
   )
   user.authentications << authentication
   return user
 end

 # grab google to access google for user data
 def google_token
   x = self.authentications.find_by(provider: 'google_oauth2')
   return x.token unless x.nil?
 end
end
