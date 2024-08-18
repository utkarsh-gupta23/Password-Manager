class User < ApplicationRecord
  # Validations
  validates :username, presence: true, uniqueness: true
  validates :display_name, presence: true
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:username]

  has_many :credentials, dependent: :destroy

  def email_required?
    false
  end

  def email_changed?
    false
  end

  
end
