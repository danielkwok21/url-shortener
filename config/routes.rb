Rails.application.routes.draw do
  root to: "shortened_url#list"
  get "/details/:backhalf", to:"shortened_url#detail"
  get "/:backhalf", to:"shortened_url#redirect"
  post "/url/create", to: "shortened_url#create"
  get "/url/get", to: "shortened_url#get"
  get "/url/create", to: "shortened_url#index"
end
