module Xero
  class BaseRecord
    XERO_TOKEN_ENDPOINT = 'https://identity.xero.com/connect/token'.freeze
    XERO_API_URL        = 'https://api.xero.com/api.xro/2.0/'.freeze

    def initialize(response); end

    def self.create
      raise NotImplementedError
    end

    def self.xero_api_get(user, endpoint)
      refresh_token(user) if token_expired?(user)

      Faraday.get(XERO_API_URL + endpoint) do |req|
        req.headers['Authorization']  = "Bearer #{user.xeroAccessToken}"
        req.headers['Accept']         = 'application/json'
        req.headers['Content-Type']   = 'application/json'
        req.headers['xero-tenant-id'] = user.xeroTenantId
      end
    end

    def self.xero_api_post(user, endpoint, body)
      refresh_token(user) if token_expired?(user)
      Faraday.post(XERO_API_URL + endpoint) do |req|
        req.headers['Authorization']  = "Bearer #{user.xeroAccessToken}"
        req.headers['Accept']         = 'application/json'
        req.headers['Content-Type']   = 'application/json'
        req.headers['xero-tenant-id'] = user.xeroTenantId

        req.body = body.to_json
      end
    end

    def self.token_expired?(user)
      Time.now.to_i >= user.xeroTokenExpiresAt.to_i
    end

    def self.refresh_token(user)
      resp = xero_token(user)

      raise StandardError, "Xero Error: #{resp.status}" unless resp.status == 200

      save_token(user, resp)
    end

    def self.save_token(user, response)
      resp_hash = JSON.parse(response.body)

      user.update_columns(
        xeroAccessToken: resp_hash['access_token'],
        xeroRefreshToken: resp_hash['refresh_token'],
        xeroTokenExpiresAt: Time.now.to_i + resp_hash['expires_in']
      )
    end

    def self.xero_token(user)
      Faraday.post(XERO_TOKEN_ENDPOINT) do |req|
        req.headers['Authorization'] =
          "Basic #{Base64.strict_encode64("#{ENV['XERO_ID']}:#{ENV['XERO_SECRET']}")}"
        req.headers['Content-Type']  = 'application/x-www-form-urlencoded'
        req.body                     = URI.encode_www_form(
          grant_type: 'refresh_token',
          refresh_token: user.xeroRefreshToken
        )
      end
    end
  end
end
