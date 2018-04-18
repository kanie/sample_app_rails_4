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

require 'spec_helper'

describe Daily do
  pending "add some examples to (or delete) #{__FILE__}"
end
