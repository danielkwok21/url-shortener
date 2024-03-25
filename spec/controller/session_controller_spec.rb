require 'rails_helper'

RSpec.describe SessionController, type: :controller do
  describe "GET #index" do
    context "when user is not logged in" do
      it "renders the index template" do
        get :index

        expect(response).to render_template(:index)
      end
    end
    context "when user is logged in" do
      it "renders the index template" do
        session[:user_id] = 1

        get :index

        expect(response).to redirect_to root_path
      end
    end
  end
end