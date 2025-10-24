# Numerical Task
# General purpose numerical tracking task with flexible increment/decrement operations
# For scenarios requiring numerical tracking, e.g., weight, savings, study points, etc.
class NumericalTask < Task
  # Default operation direction: increment
  def default_operation
    :increment
  end

  def increment(value = step_value)
    value = value.to_f
    self.current_value += value
    save!
  end

  def decrement(value = step_value)
    super(value)
  end

  def set_value(value)
    super(value)
  end
end
