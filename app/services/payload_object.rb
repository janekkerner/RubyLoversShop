class PayloadObject
  attr_accessor :message, :payload, :errors

  def initialize(message: '', payload: {}, errors: {})
    @message = message
    @payload = payload
    @errors = errors
  end

  def success?
    @errors.empty?
  end
end
