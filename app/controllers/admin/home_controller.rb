module Admin
  class HomeController < ApplicationController
    before_action :must_be_admin

    def index
      @late_orders     = Order.late.count
      @orders          = Order.active.count
      @todays_orders   = Order.to_be_fulfilled(Time.zone.today).count
      @contacts        = Contact.active.count
      @urgent_contacts = Contact.urgent.count
      @states          = State.count
      @towns           = Town.count
      @products        = Product.count
      @active_products = Product.where(is_public: true).count
    end

    def xero
      auth_hash = request.env['omniauth.auth']

      current_user.update(
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
