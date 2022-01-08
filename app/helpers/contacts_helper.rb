module ContactsHelper
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
