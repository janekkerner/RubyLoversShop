# frozen_string_literal: true

class PayloadObject
  attr_accessor :payload

  def initialize(message: '', payload: {}, errors: [])
    @message = message
    @payload = payload
    @errors = errors
  end

  def success?
    @errors.empty?
  end

  def errors
    return @errors.uniq.to_sentence if @errors.is_a?(Array) && @errors.any?
    return nil if @errors.empty?

    @errors
  end

  def message
    return @message.to_sentence if @message.is_a?(Array)

    @message
  end
end
