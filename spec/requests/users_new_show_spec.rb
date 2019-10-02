require 'rails_helper'

RSpec.describe UsersController, type: :request do

  describe "GET #new" do

  def setup
    ActionMailer::Base.deliveries.clear
  end

    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template 'users/new'
    end

    it "post to right url" do
      get signup_path
      post users_path, params: { user: { name:  "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }
      assert_select 'form'
    end

    it "invalid signup information" do
      get signup_path
      count =  User.count
      post signup_path, params: { user: { name:  "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }
      expect(User.count).to eq count
      expect(response).to render_template 'shared/_error_messages'
    end

    it "valid signup with information with account activation" do
      get signup_path
      count = User.count
      post signup_path, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
      expect(User.count).not_to eq count
#      expect(response).to redirect_to user_path(User.last)
#      expect(flash.empty?).to be_falseyi
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(User.last.activated?).to be_falsey
      log_in_as(User.last)
      expect(is_logged_in?).to be_falsey
      User.first.update_attribute(:activated,    true)
      User.first.update_attribute(:activated_at, Time.zone.now)
      expect(User.last.reload.activated?).to be_truthy
    end
  end
end
