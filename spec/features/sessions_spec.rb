require 'rails_helper'

RSpec.feature SessionsController, type: :feature do
=begin
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
=end

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

=begin
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

      二番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    end
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    #     log_in_as(@user, remember_me: '1')
    #         delete logout_path
    #             # クッキーを削除してログイン
    #                 log_in_as(@user, remember_me: '0')
    #                     assert_empty cookies['remember_token']
    #                       end
=end
end
