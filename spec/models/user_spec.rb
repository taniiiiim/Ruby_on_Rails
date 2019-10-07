require 'rails_helper'

RSpec.describe User, type: :model do                                    

  it "should be valid" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    expect(@user).to be_valid
  end

  it "name should be present" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user.name = ""
    expect(@user).not_to be_valid
  end

  it "email should be present" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user.email = ""
    expect(@user).not_to be_valid
  end

  it "name should not be too long" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user.name = "a" * 51
    expect(@user).not_to be_valid
  end

  it "email should not be too long" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user.email = "a" * 244 + "@example.com"
    expect(@user).not_to be_valid
  end

  it "email should accept certain addresses" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      expect(@user).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  it "email should reject invalid addresses" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      expect(@user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
    end
  end

  it "email should be unique" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    expect(duplicate_user).not_to be_valid
  end

  it "email addresses should be saved as lower-case" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    expect(mixed_case_email.downcase).to eq @user.reload.email
  end

  it "password should be present" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user.password = @user.password_confirmation = " " * 6
    expect(@user).not_to be_valid
  end

  it "password should have a minimum value" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user.password = @user.password_confirmation = "a" * 5
    expect(@user).not_to be_valid
  end

  it "authenticated? should return false for a user with nil digest" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    expect(@user.authenticated?(:remember, '')).to be_falsey
  end

  it "associated microposts should be destroyed" do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    count = Micropost.count
    @user.destroy
    expect(count).not_to eq Micropost.count
  end

  it "should follow and unfollow a user" do
    @user1 = User.create(name: "Example User1", email: "user1@example.com",
                     password: "foobar1", password_confirmation: "foobar1")
    @user2 = User.create(name: "Example User2", email: "user2@example.com",
                     password: "foobar2", password_confirmation: "foobar2")
    expect(@user1.following?(@user2)).to be_falsey
    @user1.follow(@user2)
    expect(@user1.following?(@user2)).to be_truthy
    expect(@user2.followers.include?(@user1))
    @user1.unfollow(@user2)
    expect(@user1.following?(@user2)).to be_falsey
  end
=begin
  it "feed should have the right posts" do

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
    @user2 = User.second
    @user2.microposts.create!(content: content, created_at: created_at)

    end
  end

  
=end
end
