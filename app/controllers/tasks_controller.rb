class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy update_value ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Current.user.tasks.build
    @task.taskable = NumericalTask.new unless @task.taskable
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Current.user.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: t("notices.task_created") }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: t("notices.task_updated"), status: :see_other }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: t("notices.task_destroyed"), status: :see_other }
      format.json { head :no_content }
    end
  end

  # POST /tasks/1/update_value
  def update_value
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

      respond_to do |format|
        format.html { redirect_to @task, notice: notice }
        format.json { render :show, status: :ok, location: @task }
      end
    rescue => e
      respond_to do |format|
        format.html { redirect_to @task, alert: t("notices.value_update_failed", error: e.message) }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(
        :emoji,
        :background,
        :name,
        :slogan,
        :taskable_type,
        taskable_attributes: [ :id, :value, :value_unit ]
      )
    end
end
