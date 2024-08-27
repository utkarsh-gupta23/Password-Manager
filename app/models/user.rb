class User < ApplicationRecord

  validates :display_name, presence: true
  #tells user that password digest field needs to be encrypted
  has_secure_password

  #associations
  has_many :credentials, dependent: :destroy

  validates_presence_of :user_name
  validates_uniqueness_of :user_name
end
