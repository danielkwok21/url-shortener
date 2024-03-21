require 'rails_helper'

RSpec.describe ShortenedUrlController, type: :controller do
  describe 'get index' do
    it 'index' do
      get :list
      expect(response).to render_template(:index)
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
        expect(flash[:alert]).to include("Error: This record violates a unique constraint.")
      end
    end
  end
end