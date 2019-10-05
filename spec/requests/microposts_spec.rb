require "rails_helper"

RSpec.describe "How microposts align in the User page", type: :request do

  include ApplicationHelper

  before do
    User.create!(name:  "Example User",
                 email: "user@example.com",
                 password:              "password",
                 password_confirmation: "password",
                 activated: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(name:  name,
                     email: email,
                     password:              password,
                     password_confirmation: password)
    end
    30.times do |n|
      content = Faker::Lorem.sentence(5)
      created_at = 42.days.ago
    @user = User.first
    @user.microposts.create!(content: content, created_at: created_at)
    @user1 = User.second
    @user1.microposts.create!(content: content, created_at: created_at)
    end
  end

  it "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
#    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  it "should not create post without login" do
    count = Micropost.count
    post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    expect(count).to eq Micropost.count
  end

  it "should not delete post without login" do
    count = Micropost.count
    delete micropost_path(Micropost.first)
    expect(count).to eq Micropost.count
  end

  it "should redirect destroy for wrong micropost" do
    log_in_as(@user)
    expect(is_logged_in?).to be_truthy
    micropost = @user1.microposts.first
    count = Micropost.count
    delete micropost_path(micropost)
    expect(count).to eq Micropost.count
    expect(response).to redirect_to root_url
  end

  it "micropost interface" do
    log_in_as(@user)
    get root_path
#    assert_select 'div.pagination'
    count = Micropost.count
    post microposts_path, params: { micropost: { content: "" } }
    expect(count).to eq Micropost.count
    assert_select 'div#error_explanation'

    content = "This micropost really ties the room together"
    count = Micropost.count
    post microposts_path, params: { micropost: { content: content } }
    expect(count).not_to eq Micropost.count
    expect(response).to redirect_to root_url
    follow_redirect!
    assert_match content, response.body

    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    count = Micropost.count
    delete micropost_path(first_micropost)
    expect(count).not_to eq Micropost.count

    get user_path(@user1)
    assert_select 'a', text: 'delete', count: 0
  end

end
