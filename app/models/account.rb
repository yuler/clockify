class Account < ApplicationRecord
  belongs_to :owner, polymorphic: true

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  def personal?
    owner.is_a?(User)
  end
  def team?
    owner.is_a?(Team)
  end
end
