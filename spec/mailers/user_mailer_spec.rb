require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "account_activation" do

    it "renders the headers" do
      user = User.create( name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" )
      user.activation_token = User.new_token
      mail = UserMailer.account_activation(user)
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      user = User.create( name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" )
      user.activation_token = User.new_token
      mail = UserMailer.account_activation(user)
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(user.activation_token)
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  describe "password_reset" do

    it "renders the headers" do
      user = User.create( name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" )
      user.reset_token = User.new_token
      mail = UserMailer.password_reset(user)
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      user = User.create( name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" )
      user.reset_token = User.new_token
      mail = UserMailer.password_reset(user)
      expect(mail.body.encoded).to match(user.reset_token)
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end
