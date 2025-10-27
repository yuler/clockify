require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "numerical task" do
    task = tasks(:numerical)
    assert task.numerical_task?

    initial_value = task.numerical_task.value
    assert_equal initial_value, task.numerical_task.value
    task.numerical_task.increment(10)
    assert_equal initial_value + 10, task.numerical_task.value

    task.numerical_task.set(20)
    assert_equal 20, task.numerical_task.value

    task.numerical_task.decrement(5)
    assert_equal 15, task.numerical_task.value
    assert_equal 3, task.task_entries.count
    assert_equal "decrement", task.task_entries.last.operation
    last_entry = task.task_entries.last
    assert last_entry.operation_decrement?
    assert_equal 20, last_entry.value_before
    assert_equal 5, last_entry.value
    assert_equal 15, last_entry.value_after
  end
end
