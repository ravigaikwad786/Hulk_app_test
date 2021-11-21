#create a main sample user
User.create!(
  name: "Example User",
  email: "example@railssample.com",
  password: "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now,
)
10.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railssample.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)

  #generate post
  users = User.order(:created_at).take(6)
  50.times do
    title = Faker::Lorem.sentence
    author = Faker::Name.name
    description = Faker::Lorem.sentence(word_count: 5)
    tag = Faker::Lorem.words(number: 4)
    users.each { |user|
      user.posts.create!(
        title: title,
        author: author,
        description: description,
        tag: tag,
      )
    }
  end
end
