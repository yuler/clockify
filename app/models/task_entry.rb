class TaskEntry < ApplicationRecord
  belongs_to :task
  belongs_to :user

  enum :operation, %w[ increment decrement set ].index_by(&:itself), default: :increment, prefix: true

  # Validations
  validates :value_before, presence: true, numericality: true
  validates :value_after, presence: true, numericality: true
  validates :operation, presence: true
end
