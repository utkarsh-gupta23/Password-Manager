require 'rails_helper'

RSpec.describe User, type: :model do

  it "is not valid without a user_name" do
    expect(
      User.new(user_name: nil, display_name: "User 1", password: "password")
    ).not_to be_valid
  end

  it "is not valid without a display_name" do
    expect(
      User.new(user_name: "user1", display_name: nil,password: "password")
    ).not_to be_valid
  end

  it "is not valid without a password" do
    expect(
      User.new(user_name: "user1", display_name: "User 1",password: nil)
    ).not_to be_valid
  end

  it "is valid with a title, content, user_id" do
    expect(
      User.new(user_name: "user1", display_name: "User 1",password: "password")
    ).to be_valid
  end

  it "has many credentials" do
    user = User.create(user_name: "user1",display_name: "User 1", password: "password")

    credential_1 = Credential.create(
      title: "facebook",
      username: "bruh",
      website: "facebook.com",
      password: "password",
      user_id: user.id
    )
    credential_2 = Credential.create(
      title: "snap",
      username: "blabla",
      website: "snapchat.com",
      password: "password",
      user_id: user.id
    )
    expect(user.credentials).to include(credential_1, credential_2)
  end

  it "is valid with a unique user_name" do
    User.create(user_name: "user1", display_name: "User 1", password: "password")
    user = User.new(user_name: "user2", display_name: "User 2", password: "password")
    expect(user).to be_valid
  end

  it "is not valid with a duplicate user_name" do
    User.create(user_name: "user1", display_name: "User", password: "password")
    user = User.new(user_name: "user1", display_name: "User", password: "password")
    expect(user).not_to be_valid
    expect(user.errors[:user_name]).to include("has already been taken")
  end

end
