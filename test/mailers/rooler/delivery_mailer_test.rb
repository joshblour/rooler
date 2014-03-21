require 'test_helper'

module Rooler
  class DeliveryMailerTest < ActionMailer::TestCase
        
    setup do 
      Rooler::Rule.class_eval { liquid_methods :name }
    end
    
    test "deliver" do
      template = create(:template, 
                  to: "{{rule.name}}@to.com", 
                  cc: "{{rule.name}}@cc.com", 
                  subject: "subject is: {{rule.name}}", 
                  body: "body is: {{rule.name}}"
                  )
      rule = create(:rule, name: 'test_name', template: template)
      
      delivery = create(:delivery, rule: rule, deliverable: rule)
      email = DeliveryMailer.send_mail(delivery).deliver

      assert !ActionMailer::Base.deliveries.empty?
      assert_equal ['test_name@to.com'], email.to
      assert_equal ['test_name@cc.com'], email.cc
      assert_equal 'subject is: test_name', email.subject
      assert_equal 'body is: test_name', email.body.to_s
    end
  end
end
