require "application_system_test_case"

class CredentialsTest < ApplicationSystemTestCase
  setup do
    @credential = credentials(:one)
  end

  test "visiting the index" do
    visit credentials_url
    assert_selector "h1", text: "Credentials"
  end

  test "should create credential" do
    visit credentials_url
    click_on "New credential"

    fill_in "Password", with: @credential.password
    fill_in "Title", with: @credential.title
    fill_in "User", with: @credential.user_id
    fill_in "Username", with: @credential.username
    fill_in "Website", with: @credential.website
    click_on "Create Credential"

    assert_text "Credential was successfully created"
    click_on "Back"
  end

  test "should update Credential" do
    visit credential_url(@credential)
    click_on "Edit this credential", match: :first

    fill_in "Password", with: @credential.password
    fill_in "Title", with: @credential.title
    fill_in "User", with: @credential.user_id
    fill_in "Username", with: @credential.username
    fill_in "Website", with: @credential.website
    click_on "Update Credential"

    assert_text "Credential was successfully updated"
    click_on "Back"
  end

  test "should destroy Credential" do
    visit credential_url(@credential)
    click_on "Destroy this credential", match: :first

    assert_text "Credential was successfully destroyed"
  end
end
