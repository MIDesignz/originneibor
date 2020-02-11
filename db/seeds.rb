# user = User.create(email: "dev@stephwag.com", password:"password", password_confirmation: "password", roles: ['user'])

# c = Campaign.create(name: "Build a house", description: "Build a really big house for me", image_url: "/assets/angle/bg1.jpg")
# Campaign.create(name: "Need help with roof", description: "Build a really big house for me", image_url: "/assets/angle/bg1.jpg")
# Campaign.create(name: "Another Campaign", description: "Build a really big house for me",image_url: "/assets/angle/bg1.jpg")
# Campaign.create(name: "And Another Campaign", description: "Build a really big house for me", image_url: "/assets/angle/bg1.jpg")
# Campaign.create(name: "Campaign Title", description: "Build a really big house for me", image_url: "/assets/angle/bg1.jpg")
# Campaign.create(name: "More Campaigns Please", description: "Build a really big house for me", image_url: "/assets/angle/bg1.jpg")


# 20.times do |i|
#   Campaign.first.contributions.create(user_id: User.first.id, donation_amount: 5, donation_type: 0)
# end
# admin = User.create(email: "admin@example.com", password:"password", password_confirmation: "password", roles: ['admin'])


# User.all.each do |user|
#   if user.email == "admin@example.com"
#     user.update(roles: ['admin'])
#   else
#     user.update(roles: ['user'])
#   end
# end

GlobalSetting.create(we_pay_client_id: "136807", we_pay_client_secret: "02cab18e7e", commission_rate: 10, campaigns_require_approval: true)