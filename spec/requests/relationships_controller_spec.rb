require 'rails_helper'

RSpec.describe "relationship controller", type: :request do

before do
    @user1 = User.create(name: "Example User1", email: "user1@example.com",
                     password: "foobar1", password_confirmation: "foobar1")
    @user2 = User.create(name: "Example User2", email: "user2@example.com",
                     password: "foobar2", password_confirmation: "foobar2")
    @relationship = Relationship.create(follower_id: User.first.id, followed_id: User.last.id)
end

  it "create should require logged-in user" do
    count = Relationship.count
    post relationships_path
    expect(count).to eq Relationship.count
    assert_redirected_to login_url
  end

  it "destroy should require logged-in user" do
    count = Relationship.count
    delete relationship_path(@relationship)
    expect(count).to eq Relationship.count
    assert_redirected_to login_url
  end

end
