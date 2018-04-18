# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  content     :string
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  status      :string
#  project_id  :integer
#  planed_time :integer
#  actual_time :integer
#  order       :integer
#  title       :string
#

class Task < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :project
  has_many :dailies, dependent: :destroy
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  aasm column: :status do
    state :not_started, :initial => true
    state :working
    state :done

    event :start do
      transitions :from => :not_started, :to => :working
    end

    event :finish do
      transitions :from => :working, :to => :done
    end
  end

  DISPLAY_STATUS = {
    not_started: "未着手",
    working: "仕掛中",
    done: "完了"
  }

  def status_for_display
    DISPLAY_STATUS[self.status.to_sym]
  end

  # Returns tasks from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
