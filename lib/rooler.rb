require "rooler/engine"
require 'rooler/liquid_filters'
require 'liquid'
require 'ckeditor'
require 'simple_form'
require 'rubytree'

module Rooler  
  mattr_accessor :from_email, :base_controller
  
  self.from_email ||= 'default@myapp.com'
  self.base_controller ||= 'ActionController::Base'
    
  
  def self.process_scheduled_rules
    Rule.ready_to_be_checked.each do |rule|
      begin
        rule.process
      rescue => error
        Rails.logger.error("RULE ERROR: rule id #{rule.id} - #{error}")
      end
    end
  end
  
  def self.clear_non_applicable_deliveries
    Rule.all.each do |rule|
      begin
        rule.clear_non_applicable_deliveries
      rescue => error
        Rails.logger.error("RULE ERROR: rule_id #{rule.id} - #{error}")
      end
    end
  end
  
  def self.deliver_pending_emails
    Delivery.undelivered.each do |delivery|
      begin
        delivery.update_column(:delivered_at, Time.now) if DeliveryMailer.send_mail(delivery).deliver
      rescue => error
        Rails.logger.error("DELIVERY ERROR: delivery id #{delivery.id} - #{error}")
      end
    end
  end
  
end
