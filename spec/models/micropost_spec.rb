require 'rails_helper'

RSpec.describe Micropost, type: :request do

  before do
    post users_path, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
    @user = assigns(:user)
    @user.update_attribute(:activated,    true)
    @user.update_attribute(:activated_at, Time.zone.now)
    @micropost = @user.microposts.create!(content: "Lorem ipsum", created_at: 1.years.ago)
    @micropost1 = @user.microposts.create!(content: "taniiiiim")
  end

  it "should be valid" do
    expect(@micropost.valid?).to be_truthy
  end

  it "user id should be present" do
    @micropost.user_id = nil
    expect(@micropost.valid?).to be_falsey
  end

  it "content should be present" do
    @micropost.content = "   "
    expect(@micropost.valid?).to be_falsey
  end

  it "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    expect(@micropost.valid?).to be_falsey
  end

  it "order should be most recent first" do
    expect(@micropost1).to eq Micropost.first
  end

end
