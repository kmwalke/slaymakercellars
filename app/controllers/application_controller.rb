class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def wine_list
    @wine_list || Vinochipper.wine_list(3005)
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def logged_in?
    return true unless current_user.nil?

    flash[:notice]             = 'You must log in to see this page.'
    session[:orig_destination] = request.path
    redirect_to login_path
  end

  def xero_api_get(xero_endpoint)
    return unless current_user

    refresh_token if token_expired?

    Faraday.get(xero_endpoint) do |req|
      req.headers['Authorization']  = "Bearer #{current_user.xeroAccessToken}"
      req.headers['Accept']         = 'application/json'
      req.headers['Content-Type']   = 'application/json'
      req.headers['xero-tenant-id'] = current_user.xeroTenantId
    end
  end

  private

  def token_expired?
    return unless current_user

    Time.now.to_i >= current_user.xeroTokenExpiresAt.to_i
  end

  def refresh_token
    return unless current_user

    xero_token_endpoint       = 'https://identity.xero.com/connect/token'
    refresh_request_body_hash = {
      grant_type: 'refresh_token',
      refresh_token: current_user.xeroRefreshToken
    }

    resp = Faraday.post(xero_token_endpoint) do |req|
      req.headers['Authorization'] =
        "Basic #{Base64.strict_encode64("#{ENV['XERO_ID']}:#{ENV['XERO_SECRET']}")}"
      req.headers['Content-Type']  = 'application/x-www-form-urlencoded'
      req.body                     = URI.encode_www_form(refresh_request_body_hash)
    end

    if resp.status == 200
      save_xero_info(resp)
    else
      redirect_to controller: 'home', action: 'index'
    end
  end

  def save_xero_info(response)
    resp_hash = JSON.parse(response.body)

    current_user.xeroAccessToken    = resp_hash['access_token']
    current_user.xeroRefreshToken   = resp_hash['refresh_token']
    current_user.xeroTokenExpiresAt = Time.now.to_i + resp_hash['expires_in']
    current_user.save
  end
end
