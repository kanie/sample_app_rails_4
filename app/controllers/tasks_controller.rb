class TasksController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @project = Project.find(params[:project_id])
    @task = current_user.tasks.build(task_params)
    @task.project_id = @project.id
    if @task.save
      flash[:success] = "作成しました"
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

  private

    def task_params
      params.require(:task).permit(:content, :id, :status, :planed_time, :actual_time)
    end

    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      redirect_to root_url if @task.nil?
    end
end
