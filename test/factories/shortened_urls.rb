FactoryBot.define do
  factory :shortened_url do
    id {}
    original_url {}
    backhalf {}
    title {}
    created_at {Time.now}
    updated_at {Time.now}
  end
end
