class TasksController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  before_action :set_project
  before_action :set_tasks, only: [:sort, :calculate]

  def create
    @task = current_user.tasks.build(task_params)
    @task.project_id = @project.id
    if @task.save
      flash[:success] = "追加しました"
      redirect_to project_path(@project)
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def edit
    @task = @project.tasks.find_by(id: params[:id])
  end

  def update
    @task = @project.tasks.find_by(id: params[:id])

    respond_to do |format|
      if @task.update_attributes(task_params)
        format.js { render :success }
        format.html { redirect_to @project, notice: '更新しました' }
      else
        format.js { render :success }
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @task.destroy
    flash[:success] = "削除"
    redirect_to project_path(@project)
  end

  def start
    @task = Task.find_by(id: params[:task_id])
    @task.start
    if @task.save
      flash[:success] = "開始しました"
      redirect_to project_path(@project)
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def finish
    @task = Task.find_by(id: params[:task_id])
    @task.finish
    if @task.save
      flash[:success] = "完了しました"
      redirect_to project_path(@project)
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def sort
    i = 0
    @tasks.each do |task|
      # 移動したタスクにはparams[:order]を当てる
      if task.id == params[:task_id].to_i
        task.order = params[:order].to_i
        task.save
        next
      end

      # params[:order]より大きい場合はparams[:order]と被らないように+1する
      task.order = (i < params[:order].to_i ? i : i + 1)
      task.save
      i += 1
    end
    calculate

    format.js { render :success }
  end

  MAX_TIME = 300

  def calculate
    create_dalies(task_times)
    redirect_to project_path(@project)
  end

  private
  def task_times
    @tasks.order(:order).each_with_object([]) do |task, task_times|
      total_last_time = task_times.present? ? task_times.last.sum { |task_time| task_time[:time] } : 0
      # 当日の合計が上限に達している場合、翌日以降に追加する
      if [0, MAX_TIME].include?(total_last_time)
        add_div_mod_times(task.id, task.planed_time, task_times)
      # 当日の合計が上限に達していない場合、当日に追加する
      else
        # タスクの時間を全部追加すると上限を超える場合
        if MAX_TIME < total_last_time + task.planed_time
          # 超えない分だけ当日に追加し、超える分は翌日以降に追加する
          this_time = MAX_TIME - total_last_time
          task_times.last << { id: task.id, time: this_time }
          add_div_mod_times(task.id, task.planed_time - this_time, task_times)
        # 上限を超えない場合
        else
          # 当日に追加する
          task_times.last << { id: task.id, time: task.planed_time }
        end
      end
    end
  end

  def create_dalies(task_times)
    Daily.destroy_all(task_id: @tasks.map(&:id))
    task_timeses = task_times.zip(@project.start_date.business_dates(task_times.size))
    task_timeses.each do |task_times, date|
      task_times.each do |task_time|
        daily = Daily.create(
          the_date: date, task_id: task_time[:id], planed_time: task_time[:time]
        )
        daily.save
      end
    end
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_tasks
    @tasks = @project.tasks.order(:order)
  end

  def task_params
    params.require(:task).permit(:content, :id, :status, :planed_time, :actual_time, :user_id)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    redirect_to root_url if @task.nil?
  end

  # 最大時間で分割してタスクを追加する
  # MAX_TIME = 300
  # task_id = 1, planed_time = 720, task_times = {}
  # の場合、720 ÷ 300 = 2あまり120なので、300を2回、余った120を1回追加するので、戻り値は以下の通り
  # task_times = [[ { id: 1, time: 300 } ], [ { id: 1, time: 300 } ], [ { id: 1, time: 120 } ]]
  def add_div_mod_times(task_id, planed_time, task_times)
    div, mod = planed_time.divmod(MAX_TIME)
    div.times { |i| task_times << [{ id: task_id, time: MAX_TIME }] }
    task_times << [{ id: task_id, time: mod }] unless mod.zero?
  end
end
