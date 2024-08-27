require 'rails_helper'

RSpec.describe Credential, type: :model do
  let(:user) { User.create!(user_name: "testuser", password: "password", display_name: "Test User") }

  it "is valid with valid attributes" do
    credential = Credential.new(user: user, title: "Example Title", username: "example_user", password: "password123", website: "http://example.com")
    expect(credential).to be_valid
  end

  it "is not valid without a title" do
    credential = Credential.new(user: user, username: "example_user", password: "password123", website: "http://example.com")
    expect(credential).not_to be_valid
  end

  it "is not valid without a username" do
    credential = Credential.new(user: user, title: "Example Title", password: "password123", website: "http://example.com")
    expect(credential).not_to be_valid
  end

  it "is not valid without a password" do
    credential = Credential.new(user: user, title: "Example Title", username: "example_user", website: "http://example.com")
    expect(credential).not_to be_valid
  end

  it "is not valid without a website" do
    credential = Credential.new(user: user, title: "Example Title", username: "example_user", password: "password123")
    expect(credential).not_to be_valid
  end

end
