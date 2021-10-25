module Admin
  class HomeController < ApplicationController
    before_action :logged_in?

    def index
      @late_orders     = Order.where('delivery_date < ? and fulfilled_on is NULL', Date.today).count
      @orders          = Order.where(fulfilled_on: nil).count
      @todays_orders   = Order.where(fulfilled_on: nil, delivery_date: Date.today).count
      @contacts        = Contact.count
      @urgent_contacts = Contact.urgent.count
      @states          = State.count
      @towns           = Town.count
      @products        = Product.count
      @active_products = Product.where(is_public: true).count
    end

    def xero
      auth_hash = request.env['omniauth.auth']

      current_user.update_columns(
        xeroUid: auth_hash['uid'],
        xeroAccessToken: auth_hash['credentials']['token'],
        xeroRefreshToken: auth_hash['credentials']['refresh_token'],
        xeroTenantId: auth_hash['extra']['xero_tenants'][0]['tenantId'],
        xeroTokenExpiresAt: auth_hash['credentials']['expires_at']
      )

      redirect_to '/admin', notice: 'Xero Connected!'
    end
  end
end
