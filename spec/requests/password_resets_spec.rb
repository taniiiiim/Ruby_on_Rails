require 'rails_helper'

RSpec.describe "password reset", type: :request do

  describe "password resets" do

  def setup
    ActionMailer::Base.deliveries.clear    
  end

    it "render forgot password" do
      get new_password_reset_path
      expect(response).to render_template 'password_resets/new'
    end

    it "invalid email" do
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(flash.empty?).to be_falsey
      expect(response).to render_template 'password_resets/new'
    end

    it "valid email" do
      post users_path, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
      user = assigns(:user)
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
    ActionMailer::Base.deliveries.clear    
      post password_resets_path,
           params: { password_reset: { email: user.email } }
      expect(user.reset_digest).not_to eq user.reload.reset_digest
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(flash.empty?).to be_falsey
      expect(response).to redirect_to root_url
    end
  end

  describe "password reset form" do

    before do
      post users_path, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
      user = assigns(:user)
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      ActionMailer::Base.deliveries.clear    
      @user = assigns(:user)
      @user.reset_token = User.new_token
      @user.update_attribute(:reset_digest,  User.digest(@user.reset_token))
      @user.update_attribute(:reset_sent_at, Time.zone.now)
    end

    it "invalid email" do
      get edit_password_reset_path(@user.reset_token, email: "")
      expect(response).to redirect_to root_url
    end

    it "invalid user" do
      user = @user
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to redirect_to root_url
    end

    it "wrong token" do
      get edit_password_reset_path('wrong token', email: @user.email)
      expect(response).to redirect_to root_url
    end

    it "invalid reset password" do
      user = @user
      get edit_password_reset_path(user.reset_token, email: user.email)
      
      expect(response).to render_template 'password_resets/edit'
      assert_select "input[name=email][type=hidden][value=?]", user.email

      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
      assert_select 'div#error_explanation'

      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
      assert_select 'div#error_explanation'

      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }


      expect(is_logged_in?).to be_truthy
      expect(flash.empty?).to be_falsey
      assert_redirected_to user
    end
  end
end
