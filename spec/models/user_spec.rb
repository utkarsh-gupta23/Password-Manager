require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(username: "user1", display_name: "8889995678", email: "jsmith@sample.com" , password: "hello World")}
  it "a demo"  do
    expect(subject.valid?).to_not be_valid
  end
  it "name test" do
    expect(subject.username).to  eql("user1")
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
