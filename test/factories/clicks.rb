FactoryBot.define do
  factory :click do
    id {}
    shortened_url_id {}
    ip_address {"dummy ip_address"}
    user_agent {"dummy user_agent"}
    referrer {"dummy referrer"}
    geolocation {"dummy geolocation"}
    device_type {"dummy device_type"}
    browser {"dummy browser"}
    os {"dummy os"}
    country {"dummy country"}
    created_at {Time.now}
    updated_at {Time.now}
  end
end
