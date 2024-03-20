Rails.application.routes.draw do
  root to: "shortened_url#list"
  get "/details/:backhalf", to:"shortened_url#detail"
  post "url/create", to: "shortened_url#create"
  get "url/get", to: "shortned_url#get"
  get "/create", to: "main#create"
end
