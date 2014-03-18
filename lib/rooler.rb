require "rooler/engine"
require 'rooler/liquid_filters'
require 'liquid'
require 'ckeditor'
require 'simple_form'

module Rooler
  BaseController ||= ActionController::Base
  
  def self.process_scheduled_rules
    Rule.ready_to_be_checked.each(&:process)
  end
  
  def self.clear_non_applicable_deliveries
    Rule.all.each(&:clear_non_applicable_deliveries)
  end
  
  def self.deliver_pending_emails
    deliveries = Delivery.undelivered
    deliveries.each do |delivery|
      if DeliveryMailer.send_mail(delivery).deliver
        delivery.update_column(:delivered_at, Time.now)
      end
    end
  end
  
end
