require 'test_helper'

class RoolerTest < ActiveSupport::TestCase
  
  test "processes scheduled rules" do
    rule = create(:rule, check_frequency: 1.minute)
    
    assert_difference 'Rooler::Delivery.count' do
      Rooler.process_scheduled_rules
    end
    
    assert_equal rule, Rooler::Delivery.last.deliverable
  end
  
  
  test 'delivers pending emails' do
    delivery = create(:delivery)
    Rooler.deliver_pending_emails
    assert !ActionMailer::Base.deliveries.empty?
    assert_not_nil delivery.reload.delivered_at
  end
  
  
end
