class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Accounts
  has_one :personal_account, as: :owner, class_name: "Account", dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships

  normalizes :email, with: ->(e) { e.strip.downcase }

  after_create :create_default_personal_account

  private
    def create_default_personal_account
      account = accounts.new(owner: self, name: name)
      account.memberships.new(user: self, role: Membership.administrator)
    end
end
