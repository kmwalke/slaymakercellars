module ApplicationHelper
  def humanize_time(time)
    time.strftime('%I:%M %p')
  end

  def humanize_date(date)
    date.strftime('%a, %b %d, %Y')
  end

  def humanize_date_time(date_time)
    date_time.strftime('%A, %B %d, %Y - %I:%M %p')
  end
end
