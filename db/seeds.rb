#create a main sample user

User.create!(
			name: "Example User",
			email:"example@railssample.com",
			password:"foobar",
			password_confirmation:"foobar",
			admin:true ,
			activated:true ,
			activated_at: Time.zone.now
			)
99.times do |n|
	name = Faker::Name.name 
	email = "example-#{n+1}@railssample.com"
	password = "password"
	User.create!(name: name,
				 email: email,
				 password: password,
				 password_confirmation: password,
				 activated:true,
				 activated_at:Time.zone.now)
end