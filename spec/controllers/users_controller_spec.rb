require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template 'users/new'
    end

    it "post to right url" do
      post :create, params: { user: { name:  "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }
      assert_select 'form[action="/signup"]'
    end

    it "invalid signup information" do
      get :new
      count =  User.count
      post :create, params: { user: { name:  "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }
      expect(User.count).to eq count
      expect(response).to render_template 'shared/_error_messages'
    end

    it "valid signup information" do
      get :new
      count = User.count
      post :create, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
      expect(User.count).not_to eq count
      expect(response).to redirect_to "/users/#{User.last[:id]}"
      expect(flash.empty?).to be_falsey
    end
  end
end
