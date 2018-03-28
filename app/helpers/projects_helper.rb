module ProjectsHelper
  def diff(daily)
    actual_time = daily.try(:actual_time)
    planed_time = daily.try(:planed_time)
    return '' if actual_time.blank? && planed_time.blank?
    (actual_time || 0) - (planed_time || 0)
  end
end
