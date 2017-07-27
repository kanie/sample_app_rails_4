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

  def destroy
    @task.destroy
    redirect_to root_url
  end

  def start
    @task = current_user.tasks.find_by(id: params[:task_id])
    @task.start
    if @task.save
      flash[:success] = "開始しました"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def finish
    @task = current_user.tasks.find_by(id: params[:task_id])
    @task.finish
    if @task.save
      flash[:success] = "完了しました"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  private

    def task_params
      params.require(:task).permit(:content)
    end

    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      redirect_to root_url if @task.nil?
    end
end
