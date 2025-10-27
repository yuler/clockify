require "test_helper"

class TaskEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @task = tasks(:one)
    sign_in_as @user
  end

  test "should create task entry with increment operation" do
    assert_difference("TaskEntry.count") do
      post task_task_entries_url(@task), params: { operation: "increment", value: 5 }
    end

    assert_redirected_to task_url(@task)
  end

  test "should create task entry with decrement operation" do
    assert_difference("TaskEntry.count") do
      post task_task_entries_url(@task), params: { operation: "decrement", value: 3 }
    end

    assert_redirected_to task_url(@task)
  end

  test "should create task entry with set operation" do
    assert_difference("TaskEntry.count") do
      post task_task_entries_url(@task), params: { operation: "set", value: 10 }
    end

    assert_redirected_to task_url(@task)
  end

  test "should handle invalid operation" do
    assert_no_difference("TaskEntry.count") do
      post task_task_entries_url(@task), params: { operation: "invalid", value: 5 }
    end

    assert_redirected_to task_url(@task)
    assert_match(/failed/i, flash[:alert])
  end
end
