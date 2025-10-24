# Duration Task
# For tracking time-based activities, e.g., 30 minutes of English study, 1 hour of jogging, 20 minutes of meditation, etc.
class DurationTask < Task
  # Default operation direction: increment
  def default_operation
    :increment
  end

  # Inherits increment, decrement, and set_value from parent Task class
  # No need to override - uses default calculate_new_value implementation
end
