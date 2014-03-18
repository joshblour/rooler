require 'test_helper'

class RoolerTest < ActiveSupport::TestCase
  
  test "processes scheduled rules" do
    foo = Foo.create
    rule = create(:rule, klass_name: 'Foo', klass_finder_method: 'active_record_finder',  check_frequency: 1.minute)
        
    assert_difference 'Rooler::Delivery.count' do
      Rooler.process_scheduled_rules
    end
    
    assert_equal foo, Rooler::Delivery.last.deliverable
  end
  
  test 'resets resetable deliveries' do
    foo = Foo.create(active: true)
    rule = create(:rule, klass_name: 'Foo', klass_finder_method: 'active_finder')
    rule.process    
    foo.update_attributes(active: false)
    
    assert_difference 'Rooler::Delivery.count', -1 do
      Rooler.clear_non_applicable_deliveries
    end
    
  end
  
  
  test 'delivers pending emails' do
    delivery = create(:delivery)
    Rooler.deliver_pending_emails
    assert !ActionMailer::Base.deliveries.empty?
    assert_not_nil delivery.reload.delivered_at
  end
  
  
end
