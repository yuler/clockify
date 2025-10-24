class TaskEntry < ApplicationRecord
  belongs_to :task
  belongs_to :user

  # Operation types
  enum operation: {
    increment: "increment",
    decrement: "decrement",
    set: "set"
  }, _prefix: true

  # Validations
  validates :value, presence: true, numericality: true
  validates :value_before, presence: true, numericality: true
  validates :value_after, presence: true, numericality: true
  validates :operation, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :today, -> { where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :this_week, -> { where(created_at: Time.current.beginning_of_week..Time.current.end_of_week) }
  scope :this_month, -> { where(created_at: Time.current.beginning_of_month..Time.current.end_of_month) }
end
