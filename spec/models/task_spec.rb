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

require 'spec_helper'

describe Task do

  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is not idiomatically correct.
    @task = Task.new(content: "Lorem ipsum", user_id: user.id)
  end

  subject { @task }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

  describe "when user_id is not present" do
    before { @task.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @task.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @task.content = "a" * 141 }
    it { should_not be_valid }
  end
end
