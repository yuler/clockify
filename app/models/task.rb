class Task < ApplicationRecord
  belongs_to :user
  delegated_type :taskable, types: Taskable::TYPES, inverse_of: :task
  has_many :task_entries, dependent: :destroy

  alias_method :entries, :task_entries

  enum :status, %w[ active paused completed archived ].index_by(&:itself), default: :active

  validates :name, presence: true, length: { maximum: 20 }
end
