class AddProjectReferencesToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :project, index: true, foreign_key: true
  end
end
