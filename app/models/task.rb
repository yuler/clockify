class Task < ApplicationRecord
  belongs_to :user
  has_many :entries, class_name: "TaskEntry", dependent: :destroy

  enum status: {
    active: "active",
    paused: "paused",
    completed: "completed",
    archived: "archived"
  }

  enum operation: {
    increment: "increment",
    decrement: "decrement",
    set: "set"
  }, _prefix: true

  enum cycle_reset_type: {
    none: "none",
    daily: "daily",
    weekly: "weekly",
    monthly: "monthly",
    custom_days: "custom_days"
  }, _prefix: true

  validates :name, presence: true, length: { maximum: 100 }
  validates :type, presence: true
  validates :current_value, :step_value, presence: true, numericality: true
  validates :theme_emoji, length: { maximum: 10 }, allow_blank: true
  validates :theme_color, length: { maximum: 7 }, allow_blank: true
  validates :step_unit, length: { maximum: 50 }, allow_blank: true
  validates :cycle_reset_days, numericality: { only_integer: true, greater_than: 0 }, if: :cycle_reset_type_custom_days?

  # Core operation methods - subclasses can override to customize behavior
  def increment(value = step_value)
    with_entry_tracking(:increment, value) do
      apply_increment(value)
    end
  end

  def decrement(value = step_value)
    with_entry_tracking(:decrement, value) do
      apply_decrement(value)
    end
  end

  def set_value(value)
    with_entry_tracking(:set, value) do
      apply_set(value)
    end
  end

  def reset
    set_value(0)
  end

  protected

    # Template method for applying increment - subclasses can override
    def apply_increment(value)
      self.current_value += value
    end

    # Template method for applying decrement - subclasses can override
    def apply_decrement(value)
      self.current_value -= value
    end

    # Template method for applying set - subclasses can override
    def apply_set(value)
      self.current_value = value
    end

  private

    # Wraps operation with transaction and entry tracking
    def with_entry_tracking(operation, value, &block)
      transaction do
        value_before = current_value
        block.call
        save!
        entries.create!(
          user: user,
          operation: operation,
          value: value,
          value_before: value_before,
          value_after: current_value
        )
      end
      true
    rescue => e
      errors.add(:base, e.message)
      false
    end
end
