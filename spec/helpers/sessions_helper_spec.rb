require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
=begin
    describe 'current user branches with right condition' do
      before do
        post signup_path, params: { user: { name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
        remember(User.last)
      end

      it "current_user returns right user when session is nil" do
        expect(current_user).to eq User.last
        expect(is_logged_in?).to be_truthy
      end
    end
=end
end
