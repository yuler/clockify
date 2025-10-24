# Reduction Task
# For reducing certain behaviors, e.g., quit smoking, reduce coffee intake, reduce screen time, etc.
# Supports both increment (relapse) and decrement (progress) operations
class ReductionTask < Task
  # Default operation direction: decrement
  def default_operation
    :decrement
  end

  # Inherits increment, decrement, and set_value from parent Task class
  # Increment records increase in undesired behavior (relapse)
  # Decrement reduces undesired behavior (progress)
end
