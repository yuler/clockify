class TaskEntriesController < ApplicationController
  before_action :set_task
  allow_unauthenticated_access only: [:create]
  before_action :check_task_ownership, only: [:create]

  # POST /tasks/:task_id/task_entries
  def create
    operation = params.expect(:operation)
    value = params.expect(:value).to_i

    begin
      case operation
      when "increment"
        @task.taskable.increment(value)
        notice = t("notices.value_incremented", value: value)
      when "decrement"
        @task.taskable.decrement(value)
        notice = t("notices.value_decremented", value: value)
      when "set"
        @task.taskable.set(value)
        notice = t("notices.value_set", value: value)
      else
        raise ArgumentError, "Invalid operation"
      end

      # Reload the task to get updated values
      @task.reload
      
      # Broadcast the update to all viewers
      @task.broadcast_replace_to(@task, "task_updates", partial: "tasks/show", locals: { task: @task })

      respond_to do |format|
        format.html { redirect_to @task, notice: notice }
        format.json { render json: { success: true }, status: :created }
      end
    rescue => e
      respond_to do |format|
        format.html { redirect_to @task, alert: t("notices.value_update_failed", error: e.message) }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_task
    @task = Task.find(params.expect(:task_id))
  end

  def check_task_ownership
    unless authenticated? && @task.user == Current.user
      respond_to do |format|
        format.html { redirect_to @task, alert: t("notices.unauthorized") }
        format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
      end
    end
  end
end
