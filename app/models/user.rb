class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :tasks, dependent: :destroy
  has_many :numerical_tasks, dependent: :destroy
  has_many :progress_tasks, dependent: :destroy
  has_many :duration_tasks, dependent: :destroy
  has_many :reduction_tasks, dependent: :destroy
  has_many :custom_tasks, dependent: :destroy

  has_many :task_entries, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }
end
