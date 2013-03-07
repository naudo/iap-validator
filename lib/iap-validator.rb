require "iap-validator/version"

require 'httparty'

module IAPValidator
  class IAPValidator
    include HTTParty

    SANDBOX_URL = 'https://sandbox.itunes.apple.com'
    PRODUCTION_URL = 'https://buy.itunes.apple.com'

    base_uri SANDBOX_URL

    headers 'Content-Type' => 'application/json'
    format :json

    def self.validate_iap(data, production = false)
      base_uri PRODUCTION_URL if production

      resp = post('/verifyReceipt', :body => MultiJson.encode({ 'receipt-data' => data }) )

      if resp.code == 200
        MultiJson.decode(resp.body())
      else
        nil
      end
    end

    def self.valid_iap?(data, production = false)
      resp = validate_iap(data, production)
      !resp.nil? && resp['status'] == 0
    end


    def self.validate_subscription(data, itunes_connect_secret, production = false)
      base_uri PRODUCTION_URL if production
      resp = post('/verifyReceipt', :body => MultiJson.encode({'receipt-data' => data, 'password' => itunes_connect_secret}))

      case resp['status']
      when 21000
        raise Exceptions::InvalidJSONError
      when 21002
        raise Exceptions::MalformedReceiptDataError
      when 21003
        raise Exceptions::InvalidReceiptAuthenticationError
      when 21004
        raise Exceptions::InvalidSharedSecretError
      when 21005
        raise Exceptions::ReceiptServerUnavailableError
      when 21006
        raise Exceptions::ExpiredSubscriptionError
      when 21007
        raise Exceptions::SanboxReceiptInProductionError
      when 21008
        raise Exceptions::ProductionReceiptInSandboxError
      end

      if resp.code == 200
        MultiJson.decode(resp.body())
      else
        nil
      end
    end

    def self.valid_subscription?(data, itunes_connect_secret, production = false)
      resp = validate_subscription(data, production)
      !resp.nil? && resp['status'] == 0
    end
  end
end
