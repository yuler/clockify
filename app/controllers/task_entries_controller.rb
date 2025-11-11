class TaskEntriesController < ApplicationController
  before_action :set_task
  allow_unauthenticated_access only: [ :create ]
  before_action :check_task_ownership, only: [ :create ]

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
      broadcast_task_updates

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

  def broadcast_task_updates
    current_value = @task.taskable.value.to_i
    total_cells = 100
    filled_cells = [ current_value, total_cells ].min
    progress_percentage = (filled_cells.to_f / total_cells * 100).round(1)
    task_emoji = @task.emoji.present? ? @task.emoji : "⭐"

    # Broadcast progress stats update
    Turbo::StreamsChannel.broadcast_replace_to(
      [ @task, "task_updates" ],
      target: "progress-stats",
      partial: "tasks/progress_stats",
      locals: { task: @task, current_value: current_value, progress_percentage: progress_percentage, filled_cells: filled_cells }
    )

    # Broadcast achievement grid update
    Turbo::StreamsChannel.broadcast_replace_to(
      [ @task, "task_updates" ],
      target: "achievement-grid-container",
      partial: "tasks/achievement_grid",
      locals: { task: @task, current_value: current_value, filled_cells: filled_cells, task_emoji: task_emoji }
    )

    # Broadcast recent activity update
    recent_entries = @task.entries.order(created_at: :desc).limit(5)
    Turbo::StreamsChannel.broadcast_replace_to(
      [ @task, "task_updates" ],
      target: "recent-activity",
      partial: "tasks/recent_activity",
      locals: { recent_entries: recent_entries }
    )
  end
end
