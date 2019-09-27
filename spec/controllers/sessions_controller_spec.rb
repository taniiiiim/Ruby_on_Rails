require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  render_views
  describe "GET #new" do
    it "returns http success" do
      get  :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template 'sessions/new'
    end
  end

  describe "POST #create" do
    it "invalid signup" do
      get  :new
      expect(response).to render_template 'sessions/new'
      post :create,  params: { session: { email: "", password: "" } } 
      expect(response).to render_template 'sessions/new'
      expect(flash.empty?).to be_falsey
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get  :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template 'sessions/new'
    end
  end
end
