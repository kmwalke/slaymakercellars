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
    end

    def xero
      auth_hash = request.env['omniauth.auth']

      user                    = current_user
      user.xeroUid            = auth_hash['uid']
      user.xeroAccessToken    = auth_hash['credentials']['token']
      user.xeroRefreshToken   = auth_hash['credentials']['refresh_token']
      user.xeroTenantId       = auth_hash['extra']['xero_tenants'][0]['tenantId']
      user.xeroTokenExpiresAt = auth_hash['credentials']['expires_at']
      user.save

      redirect_to '/admin', notice: 'Xero Connected!', xeroUid: user.xeroUid
    end
  end
end
