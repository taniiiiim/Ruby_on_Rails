require 'rails_helper'


RSpec.describe "following spec", type: :request do

  before do
    @user1 = User.create(name: "Example User1", email: "user1@example.com",
                     password: "foobar1", password_confirmation: "foobar1")
    @user1.update_attribute(:activated, true)
    @user2 = User.create(name: "Example User2", email: "user2@example.com",
                     password: "foobar2", password_confirmation: "foobar2")
    @user2.update_attribute(:activated, true)
    @relationship = Relationship.create(follower_id: User.first.id, followed_id: User.last.id)
				end
=begin
  it "following page" do
    log_in_as(@user1)
    expect(is_logged_in?).to be_truthy
    get following_user_path(@user1)
    expect(@user1.following.empty?).to be_falsey
    assert_match @user1.following.count.to_s, response.body
    @user1.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  it "followers page" do
    log_in_as(@user1)
    get followers_user_path(@user1)
    expect(@user1.followers.empty?).to be_falesy
    assert_match @user1.followers.count.to_s, response.body
    @user1.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
=end
end
