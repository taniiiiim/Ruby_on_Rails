require 'rails_helper'

RSpec.describe UsersController, type: :request do

  describe "Update your profile" do

    before do
      post signup_path, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
      delete logout_path
    end

    it "unsucceessful edit" do
      User.last.update_attribute(:activated,    true)
      User.last.update_attribute(:activated_at, Time.zone.now)
      log_in_as(User.last)
      get edit_user_path(User.last)
      expect(response).to render_template 'users/edit'
      patch user_path(User.last), params: { user: { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar" } }
      expect(response).to render_template 'users/edit'
    end

    it "successful edit" do
      User.last.update_attribute(:activated,    true)
      User.last.update_attribute(:activated_at, Time.zone.now)
      log_in_as(User.last)
      get edit_user_path(User.last)
      expect(response).to render_template 'users/edit'
      patch user_path(User.last), params: { user: { name: "Foo Bar", email: "foo@bar.com", password: "", password_confirmation: "" } }
      expect(flash.empty?).to be_falsey
      expect(response.status).to eq 302
      follow_redirect!
      expect(response).to render_template 'users/show'
      name = User.last.name
      email = User.last.email
      User.last.reload
      expect(name).to eq User.last.name
      expect(email).to eq User.last.email
    end

    it "should redirect edit when logged in as wrong user" do
      post signup_path, params: { user: { name:  "Instance User", email: "user@instance.com", password: "password", password_confirmation: "password" } }
      User.last.update_attribute(:activated,    true)
      User.last.update_attribute(:activated_at, Time.zone.now)
      log_in_as(User.last)
      expect(session[:user_id].nil?).to be_falsey
      get edit_user_path(User.first)
#      expect(flash.empty?).to be_truthy
      expect(response.status).to eq 302
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end

    it "should redirect update when logged in as wrong user" do
      post signup_path, params: { user: { name:  "Instance User", email: "user@instance.com", password: "password", password_confirmation: "password" } }
      User.last.update_attribute(:activated,    true)
      User.last.update_attribute(:activated_at, Time.zone.now)
      post login_path, params: { session: { email: "user@instance.com", password: "password" } }
      patch user_path(User.first), params: { user: { name: "Ejenpro", email: "user@ejenpro.com", } }
      expect(session[:user_id].nil?).to be_falsey
      expect(response.status).to eq 302
#      expect(flash.empty?).to be_truthy
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end

    it "successful edit with friendly forwarding" do
      get edit_user_path(User.last)
      expect(response.status).to eq 302
      follow_redirect!
      expect(response).to render_template 'sessions/new'
      User.last.update_attribute(:activated,    true)
      User.last.update_attribute(:activated_at, Time.zone.now)
      log_in_as(User.last)
      expect(response.status).to eq 302
      follow_redirect!
      expect(response).to render_template 'users/edit'
      patch user_path(User.last), params: { user: { name: "Foo Bar", email: "foo@bar.com", password: "", password_confirmation: "" } }
      expect(flash.empty?).to be_falsey
      expect(response.status).to eq 302
      follow_redirect!
      expect(response).to render_template 'users/show'
      name = User.last.name
      email = User.last.email
      User.last.reload
      expect(name).to eq User.last.name
      expect(email).to eq User.last.email 
			end
=begin
    it "friendly forwarding non-repeatable" do
      get edit_user_path(User.last)
      expect(response.status).to eq 302
      follow_redirect!
      expect(session[:forwarding_url]).to eq edit_user_url(User.last)
      get login_path
      expect(session[:forwarding_url]).to eq rootn_url
      log_in_as(User.last)
      expect(response.status).to eq 302
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end
=end

    it "should not allow the admin attribute to be edited via the web" do
      log_in_as(User.first)
      expect(User.first.admin?).to be_falsey
      patch user_path(User.first), params: {
                                      user: { password:              "password",
                                              password_confirmation: "password",
                                              admin: true } }
      expect(User.first.admin?).to be_falsey
    end
  end

  describe "follow/unfollow" do

    before do
      post signup_path, params: { user: { name:  "Example User1", email: "user1@example.com", password: "password1", password_confirmation: "password1" } }
      post signup_path, params: { user: { name:  "Example User2", email: "user2@example.com", password: "password2", password_confirmation: "password2" } }
      delete logout_path
    end

  it "should redirect following when not logged in" do
    get following_user_path(User.first)
    assert_redirected_to login_url
  end

  it "should redirect followers when not logged in" do
    get followers_user_path(User.first)
    assert_redirected_to login_url
  end

  end
end

