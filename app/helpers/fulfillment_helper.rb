module FulfillmentHelper
  def active_class(amount)
    amount.positive? ? 'active' : 'inactive'
  end
end
