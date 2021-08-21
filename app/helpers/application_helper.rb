# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def bootstrap_flash_class(type)
    case type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      type.to_s
    end
  end

  def bootstrap_order_status_class(type)
    case type
    when 'new', 'pending'
      'bg-info'
    when 'failed'
      'bg-danger'
    when 'completed'
      'bg-success'
    end
  end

  def bootstrap_events_class(type)
    case type
    when 'pending', 'ready'
      'info'
    when 'canceled'
      'secondary'
    when 'confirm', 'completed', 'shipped'
      'success'
    when 'reject', 'failed'
      'danger'
    end
  end
end
