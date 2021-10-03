module ProductsHelper
  def active_sort(name, sort)
    'active' if name == sort
  end
end
