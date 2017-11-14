class Date
  def business_dates(count)
    arr = [self.bussiness_date? ? self : self.next_business_date]
    arr << arr.last.next_business_date until arr.size == count
    arr
  end

  def next_business_date
    d = self.next
    d = d.next until d.bussiness_date?
    d
  end

  def bussiness_date?
    self.workday? && !self.holiday?
  end

  def holiday?
    HolidayJp.holiday?(self)
  end
end