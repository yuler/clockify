class Task < ApplicationRecord
  belongs_to :user
  delegated_type :taskable, types: Taskable::TYPES, inverse_of: :task
  has_many :task_entries, dependent: :destroy

  alias_method :entries, :task_entries

  accepts_nested_attributes_for :taskable

  enum :status, %w[ active paused completed archived ].index_by(&:itself), default: :active

  validates :name, presence: true, length: { maximum: 20 }
  validates :background, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "must be a valid hex color" }, allow_blank: true
end
