# == Schema Information
#
# Table name: dailies
#
#  id          :integer          not null, primary key
#  planed_time :integer
#  actual_time :integer
#  the_date    :date
#  task_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Daily < ActiveRecord::Base
  belongs_to :task
end
