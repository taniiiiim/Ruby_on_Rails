require 'rails_helper'

RSpec.describe Relationship, type: :model do

  before do
    @user1 = User.create(name: "Example User1", email: "user1@example.com",
                     password: "foobar1", password_confirmation: "foobar1")
    @user2 = User.create(name: "Example User2", email: "user2@example.com",
                     password: "foobar2", password_confirmation: "foobar2")
    @relationship = Relationship.new(follower_id: User.first.id, followed_id: User.last.id)
  end

  it "should be valid" do
    expect(@relationship.valid?).to be_truthy
  end

  it "should require a follower_id" do
    @relationship.follower_id = nil
    expect(@relationship.valid?).to be_falsey
  end

  it "should require a followed_id" do
    @relationship.followed_id = nil
    expect(@relationship.valid?).to be_falsey
  end

end
