module ApplicationHelper
  MENU_URL = 'https://docs.google.com/document/d/e/2PACX-1vQcDtRD40btM88GS0rU0soRtGhddFJ3e47nQ--Z8H_Aslg663kMZTEDwQL7LJ_3JA6Yiu1l7Jyotc4W/pub'.freeze

  def humanize_time(time)
    time&.strftime('%I:%M %p')
  end

  def humanize_date(date)
    date&.strftime('%a, %b %d, %Y')
  end

  def humanize_date_time(date_time)
    date_time&.strftime('%A, %B %d, %Y - %I:%M %p')
  end

  def days_ago_in_words(from_day)
    return 'Today' if from_day == Date.today

    "#{distance_of_time_in_words(from_day, Date.today)} ago"
  end

  def sortable(name)
    link_to name, { sort: name.downcase, direction: sort_direction(name) }, { class: link_class(name) }
  end

  private

  def sort_direction(name)
    return 'asc' unless name.downcase == params[:sort]

    params[:direction] == 'asc' ? 'desc' : 'asc'
  end

  def link_class(name)
    return '' unless name.downcase == params[:sort]

    params[:direction] == 'asc' ? 'down' : 'up'
  end
end
