require 'rails_helper'

RSpec.describe "login and logout", type: :request do

  describe "login with invalid information" do
    before do
      post login_path, params: { session: { email: "user@invalid", password: "foo"} }
    end

  it 'gets an flash messages' do
    expect(response).to render_template 'sessions/new'
    expect(flash.empty?).to be_falsey
  end

  context 'access to other page' do
    before { get root_path }
      it 'is flash disappear' do
        expect(flash.empty?).to be_truthy
      end
  end
  end

  describe  "login with valid information" do

    it 'log in' do
      post users_path, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
      user = assigns(:user)
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      expect(user.activated?).to be_truthy
      log_in_as(user)
      expect(session[:user_id].nil?).to be_falsey
      expect(is_logged_in?).to be_truthy
      expect(response.status).to eq 302
      follow_redirect!
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(user)
      delete logout_path
      expect(is_logged_in?).to be_falsey
      expect(response.status).to eq 302
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path, count: 0
      assert_select "a[href=?]", user_path(user), count: 0
      delete logout_path
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", user_path(User.last), count: 0
    end

    it 'log in with cookies' do

      post users_path, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
      user = assigns(:user)
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in_as(user, remember_me: '1')
      expect(cookies['remember_token'].empty?).to be_falsey
      delete logout_path
      expect(cookies['remember_token'].empty?).to be_truthy
    end

    it 'log in without cookies' do
      post users_path, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
      user = assigns(:user)
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in_as(user, remember_me: '1')
      delete logout_path
      log_in_as(user, remember_me: '0')
      expect(cookies['remember_token'].empty?).to be_truthy
    end

  end
end
