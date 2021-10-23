class SessionsController < ApplicationController
  def new; end

  def create
    auth_hash = request.env['omniauth.auth']

    user                    = User.find_or_create_by(xeroUid: auth_hash['uid'],
                                                     name: auth_hash['info']['name'],
                                                     email: auth_hash['info']['email'])
    user.xeroAccessToken    = auth_hash['credentials']['token']
    user.xeroRefreshToken   = auth_hash['credentials']['refresh_token']
    user.xeroTenantId       = auth_hash['extra']['xero_tenants'][0]['tenantId']
    user.xeroTokenExpiresAt = auth_hash['credentials']['expires_at']
    user.save

    session[:user_id] = user.id

    redirect_to '/admin', notice: 'Logged in!', xeroUid: user.xeroUid
  end
end
