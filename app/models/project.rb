# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_date :date
#

class Project < ActiveRecord::Base
  has_many :tasks, dependent: :destroy

  def term
    self.start_date.business_dates(dailies)
  end

  def dailies
    tasks.map(&:dailies).flatten.map(&:the_date).uniq.size
  end
end
