require 'test_helper'

## It might be a bit confusing. We're using the Rule class as the the target class also. So these test rules are actually looking
## within their own class to find matches.

module Rooler
  class RuleTest < ActiveSupport::TestCase
    
    test 'scope ready_to_be_checked returns rules where last_checked_at is < than check_frequency.ago or nil' do
      create(:rule)
      assert_equal [], Rule.ready_to_be_checked 
      
      rule1 = create(:rule, check_frequency: 10.minutes, last_checked_at: 11.minutes.ago)
      rule2 = create(:rule, check_frequency: 10.minutes, last_checked_at: nil)
      
      assert_equal [rule1, rule2], Rule.ready_to_be_checked      
    end

    
    test 'check_all method finds unprocessed objects of rules class using klass_method' do
      rule = create(:rule, klass_name: 'Rooler::Rule', klass_finder_method: 'to_a')
      assert_equal [rule], rule.send(:find_by_klass)
      
      last_rule = create(:rule, klass_name: 'Rooler::Rule', klass_finder_method: 'last')
      assert_equal last_rule, last_rule.send(:find_by_klass)
      
      rule.process(last_rule)
      assert_equal [rule], rule.send(:find_by_klass)
    end
    
    
    test 'check() method runs the instance method against the provided object. returns error if they are not the same class' do
      rule = create(:rule, klass_name: 'Rooler::Rule', instance_checker_method: 'nil?')
      assert_equal false, rule.send(:check_instance, rule)

      assert_raises TypeError do
        rule.send(:check_instance, 'a string object')
      end
    end
    
    test 'creates deliveries ONCE for objects matching class rule' do
      rule = create(:rule, klass_name: 'Rooler::Rule', klass_finder_method: 'to_a')
      
      
      assert_difference 'Delivery.count' do
        rule.process
      end
      
      assert_no_difference 'Delivery.count' do
        rule.process
      end
    end
    
    test 'creates deliveries ONCE for specific object if instance method returns true' do
      true_rule = create(:rule, klass_name: 'Rooler::Rule', instance_checker_method: 'present?')
      
      assert_difference 'Delivery.count' do
        true_rule.process(true_rule)
      end
      
      assert_no_difference 'Delivery.count' do
        true_rule.process(true_rule)
      end
      
      false_rule = create(:rule, klass_name: 'Rooler::Rule', instance_checker_method: 'nil?')
      
      assert_no_difference 'Delivery.count' do
        false_rule.process(false_rule)
      end
    end
    
  end
end
