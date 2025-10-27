class NumericalTask < ApplicationRecord
  include Taskable

  def increment(value)
    value_before = self.value
    value_after = value_before + value
    create_task_entry("increment", value, value_before, value_after)
    self.value += value
    save!
  end

  def decrement(value)
    value_before = self.value
    value_after = value_before - value
    create_task_entry("decrement", value, value_before, value_after)
    self.value -= value
    save!
  end

  def set(value)
    value_before = self.value
    value_after = value
    create_task_entry("set", value, value_before, value_after)
    self.value = value
    save!
  end


  private

  def create_task_entry(operation, value, value_before, value_after)
    TaskEntry.create!(
      task: task,
      user: user,
      operation: operation,
      value: value,
      value_before: value_before,
      value_after: value_after,
    )
  end
end
