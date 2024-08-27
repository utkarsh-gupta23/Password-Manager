class Credential < ApplicationRecord
  belongs_to :user
  validates :title, :username, :password, :website, presence: true
end
