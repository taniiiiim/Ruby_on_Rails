require 'rails_helper'

RSpec.describe UsersController, type: :request do

  describe "should show all the users" do

    before do
      User.create!(name:  "Example User",
                   email: "user@example.com",
                   password:              "password",
                   password_confirmation: "password")
      99.times do |n|
        name  = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password = "password"
        User.create!(name:  name,
                     email: email,
                     password:              password,
                     password_confirmation: password)
      end
    end

    it "should redirect index when not logged in" do
      get users_path
      expect(response.status).to eq 302
      follow_redirect!
      expect(response).to render_template('sessions/new')
    end

    it "index including pagination" do     
      User.first.update_attribute(:activated,    true)
      User.first.update_attribute(:activated_at, Time.zone.now)
      log_in_as(User.first)
      get users_path
      expect(response).to render_template('users/index')
      assert_select 'div.pagination', count: 2
      User.paginate(page: 1).each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
      end
    end
  end

  describe "only admin user can delete users" do

    before do
      User.create!(name:  "Example User",
                   email: "user@example.com",
                   password:              "password",
                   password_confirmation: "password")
      99.times do |n|
        name  = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password = "password"
        User.create!(name:  name,
                     email: email,
                     password:              password,
                     password_confirmation: password)
      end
    end

    it "admin user can delete users" do
      User.first.update_attribute(:admin, true)
      User.first.update_attribute(:activated,    true)
      User.first.update_attribute(:activated_at, Time.zone.now)
      log_in_as(User.first)
      count = User.count
      delete user_path(User.second)
      expect(count).not_to eq User.count
      expect(response.status).to eq 302
      follow_redirect!
      expect(response).to render_template('users/index')
    end

    it "normal user cannot delete users" do
      User.first.update_attribute(:activated,    true)
      User.first.update_attribute(:activated_at, Time.zone.now)
      log_in_as(User.first)
      count = User.count
      delete user_path(User.second)
      expect(count).to eq User.count
      expect(response.status).to eq 302
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end
  end
end
