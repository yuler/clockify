# Progress Task
# For tracking cumulative progress towards a goal, e.g., 8 glasses of water, 30 pages read, 10 workouts, etc.
# Only supports increment operations (positive progress)
class ProgressTask < Task
  # Default operation direction: increment
  def default_operation
    :increment
  end

  protected

  # Override to prevent negative progress
  def apply_decrement(value)
    raise NotImplementedError, "ProgressTask does not support decrement operations"
  end
end
