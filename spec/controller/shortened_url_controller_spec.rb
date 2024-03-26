require 'rails_helper'

RSpec.describe ShortenedUrlController, type: :controller do
  describe 'get index' do
    context 'happy path' do
      it 'renders data correctly if logged in' do
        # seed data
        user = FactoryBot.create(:user, id:1)
        session[:user_id] = 1
        post :create, params: {
          original_url: 'https://www.google.com', title: 'title', backhalf: 'abc1', user_id: 1
        }
        post :create, params: {
          original_url: 'https://www.youtube.com', title: 'title', backhalf: 'abc2', user_id: 1
        }
        post :create, params: {
          original_url: 'https://www.facebook.com', title: 'title', backhalf: 'abc3', user_id: 1
        }

        get :list

        # assertions
        expect(response).to render_template(:index)
        expect(assigns(:shortened_urls).length).to eq(3)
        expect(assigns(:domain_name)).to eq("https://urlshortener.danielkwok.com")
      end
      it 'will not return other user\'s shortened urls' do
        # seed data
        user = FactoryBot.create(:user, id:1, email: "user1@email.com", name: "user1")
        session[:user_id] = 1
        post :create, params: {
          original_url: 'https://www.google.com', title: 'title', backhalf: 'def1'
        }
        post :create, params: {
          original_url: 'https://www.youtube.com', title: 'title', backhalf: 'def2'
        }

        user = FactoryBot.create(:user, id:2, email: "user2@email.com", name: "user2")
        session[:user_id] = 2
        post :create, params: {
          original_url: 'https://www.facebook.com', title: 'title', backhalf: 'def3'
        }

        session[:user_id] = 1
        get :list

        # assertions
        expect(response).to render_template(:index)
        expect(assigns(:shortened_urls).length).to eq(2)
        expect(assigns(:domain_name)).to eq("https://urlshortener.danielkwok.com")
      end
      it 'redirects to /login if not logged in' do
        # seed data
        post :create, params: {
          original_url: 'https://www.google.com', title: 'title', backhalf: 'abc1'
        }
        post :create, params: {
          original_url: 'https://www.youtube.com', title: 'title', backhalf: 'abc2'
        }
        post :create, params: {
          original_url: 'https://www.facebook.com', title: 'title', backhalf: 'abc3'
        }

        get :list

        # assertions
        expect(response).to redirect_to login_path
        expect(assigns(:shortened_urls)).to eq(nil)
      end
    end
  end

  describe 'POST /create' do
    context 'happy path' do
      it 'all ok' do
        expect {
            post :create, params: {
              original_url: 'https://www.google.com', title: 'title', backhalf: 'abcdef'
            }
        }.to change(ShortenedUrl, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include("URL registered successfully")
      end
      it 'title is optional' do
        expect {
            post :create, params: {
              original_url: 'https://www.google.com', title: '', backhalf: 'abcdef'
            }
        }.to change(ShortenedUrl, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end
    end
    context 'sad path' do
      it 'invalid param, missing original_url' do
        expect {
            post :create, params: {
              original_url: '', title: 'title', backhalf: 'abcdef'
            }
        }.to change(ShortenedUrl, :count).by(0)

        expect(response).to render_template(:create)
        expect(assigns(:shortened_url).errors).not_to be_nil
        expect(assigns(:shortened_url).errors.full_messages).to include("Original url can't be blank")
      end
      it 'invalid param, missing backhalf' do
        expect {
            post :create, params: {
              original_url: 'https://www.google.com', title: 'title', backhalf: ''
            }
        }.to change(ShortenedUrl, :count).by(0)

        expect(response).to render_template(:create)
        expect(assigns(:shortened_url).errors).not_to be_nil
        expect(assigns(:shortened_url).errors.full_messages).to include("Backhalf can't be blank")
      end
      it 'duplicated backhalf' do
        post :create, params: {
          original_url: 'https://www.google.com', title: 'title', backhalf: 'abcdef'
        }

        expect {
            post :create, params: {
              original_url: 'https://www.youtube.com', title: 'title', backhalf: 'abcdef'
            }
        }.to change(ShortenedUrl, :count).by(0)

        expect(response).to render_template(:create)
        expect(assigns(:shortened_url).errors).not_to be_nil
        expect(flash[:alert]).to include("Backhalf is already taken. Try choosing something more unique?")
      end
    end
  end

  describe 'get detail' do
    context 'happy path' do
      it 'renders data correctly' do
        # seed data
        shortened_url = FactoryBot.create(:shortened_url, id:1, original_url:"https://www.google.com", backhalf:"abc1")
        clicks = FactoryBot.create_list(:click, 1, id:1, shortened_url_id: shortened_url.id)

        get :detail, params: {backhalf: 'abc1'}

        # assertions
        expect(response).to render_template(:detail)
        expect(assigns(:shortened_url)).to eq(shortened_url)
        expect(assigns(:clicks)).to eq(clicks)
        expect(flash[:alert]).to_not be_present
      end
      it 'should not be able to see another user\'s shortened url\'s details' do
        # seed data
        FactoryBot.create(:user, id:1, email: "user1@email.com", name: "user1")
        shortened_url = FactoryBot.create(:shortened_url, id:1, original_url:"https://www.google.com", backhalf:"abc1", user_id: 1)
        clicks = FactoryBot.create_list(:click, 1, id:1, shortened_url_id: shortened_url.id)


        FactoryBot.create(:user, id:2, email: "user2@email.com", name: "user2")
        session[:user_id] = 2
        get :detail, params: {backhalf: 'abc1'}

        # assertions
        expect(response).to render_template(:detail)
        expect(assigns(:shortened_url)).to eq(nil)
        expect(assigns(:clicks)).to eq(nil)
        expect(flash[:alert]).to include('Error: invalid backhalf')
      end
    end
    context 'sad path' do
      it 'invalid backhalf' do
        # seed data
        shortened_url = FactoryBot.create(:shortened_url, id:1, original_url:"https://www.google.com", backhalf:"abc1")
        clicks = FactoryBot.create_list(:click, 1, id:1, shortened_url_id: shortened_url.id)

        get :detail, params: {backhalf: 'this is an invalid backhalf'}

        # assertions
        expect(response).to render_template(:detail)
        expect(assigns(:shortened_url)).to eq(nil)
        expect(assigns(:clicks)).to eq(nil)
        expect(flash[:alert]).to include('Error: invalid backhalf')
      end
    end
  end

  describe 'get redirect' do
    context 'happy path' do
      it 'redirects correctly' do
        post :create, params: {
          original_url: 'https://www.google.com', title: 'title', backhalf: 'abcdef'
        }

        # assert redirect
        get :redirect, params: {backhalf: 'abcdef'}
        expect(response).to redirect_to('https://www.google.com')

        sleep(1)

        # assert clicks is kept track
        get :detail, params: {backhalf: 'abcdef'}
        expect(assigns(:clicks).length).to eq(1)
      end
    end
  end
end