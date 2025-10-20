class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account
  enum :role, %i[ member administrator ]
end
