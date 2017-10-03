class TasksController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @project = Project.find(params[:project_id])
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
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find_by(id: params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find_by(id: params[:id])
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @project, notice: '更新しました' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end  end

  def destroy
    @task.destroy
    @project = Project.find(params[:project_id])
    flash[:success] = "削除"
    redirect_to project_path(@project)
  end

  def start
    @project = Project.find(params[:project_id])
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
    @project = Project.find(params[:project_id])
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

    redirect_to project_path(@project)
  end

  private

    def task_params
      params.require(:task).permit(:content, :id, :status, :planed_time, :actual_time)
    end

    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      redirect_to root_url if @task.nil?
    end
end
