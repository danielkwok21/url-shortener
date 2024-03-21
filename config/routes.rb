Rails.application.routes.draw do
  root to: "shortened_url#list"
  get "/details/:backhalf", to:"shortened_url#detail"
  post "create", to: "shortened_url#create"
  get "url/get", to: "shortened_url#get"
  get "/create", to: "shortened_url#index"
end
