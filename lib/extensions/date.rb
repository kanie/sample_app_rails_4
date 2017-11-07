class Date
  def next_business_date
    d = self.next
    until d.bussiness_date? do
      d = d.next
    end
    d
  end

  def bussiness_date?
    self.workday? && !self.holiday?
  end

  def holiday?
    HolidayJp.holiday?(self)
  end
end