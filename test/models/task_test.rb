require "test_helper"

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # numerical task

  test "numerical task" do
    task = tasks(:numerical_task)
    task.increment()
    assert task.valid?
  end
end
