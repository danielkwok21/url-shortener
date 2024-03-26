FactoryBot.define do
  factory :user do
    id {}
    email {"johndoe@gmail.com"}
    name {"john doe"}
    password {"123456"}
    password_confirmation {"123456"}
    created_at {Time.now}
    updated_at {Time.now}
  end
end
