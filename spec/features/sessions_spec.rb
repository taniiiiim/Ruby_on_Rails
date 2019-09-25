require 'rails_helper'

RSpec.feature SessionsController, type: :feature do

  describe "login with invalid information" do
    before do
      visit login_path
      fill_in "Email", with: ""
      fill_in "Password", with: ""
      click_button "Log in"
    end
  subject { page }

  it 'gets an flash messages' do
    is_expected.to have_selector('.alert-danger', text: 'Invalid email/password combination')
    is_expected.to have_current_path login_path
  end

  context 'access to other page' do
    before { visit root_path }
      it 'is flash disappear' do
        is_expected.to_not have_selector('.alert-danger', text: 'Invalid email/password combination')
      end
  end
  end


  describe  "login with valid information" do
    it 'log in' do
      visit login_path
      fill_in "Email", with: "tani.yuuki@lmi.ne.jp"
      fill_in "Password", with: "Treasure1131"
      click_button "Log in"
      expect(is_logged_in?).to be_truthy 
      expect(page).to have_current_path user_path(2)
      expect(page).not_to have_link "Log in", href: login_path
      click_link 'Account'
      expect(page).to have_link 'Profile', href: user_path(2) 
      expected(page).to have_link 'Log out', href: logout_path
    end

  describe "log out" do
    before do
      visit login_path
      fill_in "Email", with: "tani.yuuki@lmi.ne.jp".upcase
      fill_in "Password", with: "Treasure1131"
      click_button "Log in"
    end
    subject {page}

    it "log out"
      click_button "Account"
      click_button "Log out"
      expect(is_logged_in?).to be_falsey 
      expect(page).to have_current_path root_path
      expect(page).to have_link "Log in", href: login_path
    end
  end
end
