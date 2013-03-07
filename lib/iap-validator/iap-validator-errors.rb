module IAPValidator
  class InvalidJSONError < StandardError; end
  class MalformedReceiptDataError < StandardError; end
  class InvalidReceiptAuthenticationError < StandardError; end
  class InvalidSharedSecretError < StandardError; end
  class ReceiptServerUnavailableError < StandardError; end
  class ExpiredSubscriptionError < StandardError; end
  class SanboxReceiptInProductionError < StandardError; end
  class ProductionReceiptInSandboxError < StandardError; end
end