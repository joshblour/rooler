require 'test_helper'

## It might be a bit confusing. We're using the Rule class as the the target class also. So these test rules are actually looking
## within their own class to find matches.

module Rooler
  class RuleTest < ActiveSupport::TestCase
    
    test 'scope ready_to_be_checked returns rules where last_checked_at is < than check_frequency.ago or nil' do
      rule1 = create(:rule, check_frequency: 10.minutes, last_checked_at: 9.minutes.ago)
      rule2 = create(:rule, check_frequency: 10.minutes, last_checked_at: 11.minutes.ago)
      rule3 = create(:rule, check_frequency: 10.minutes, last_checked_at: nil)
      rule4 = create(:rule, check_frequency: nil, last_checked_at: nil)
      
      assert_equal [rule2, rule3, rule4], Rule.ready_to_be_checked      
    end

    
    test 'check_all method finds objects of rules class using klass_method' do
      foo = Foo.create
      rule = create(:rule, klass_name: 'Foo', klass_finder_method: 'active_record_finder')
      assert_equal [foo], rule.send(:find_by_klass)
      
      empty_rule = create(:rule, klass_name: 'Foo', klass_finder_method: 'empty_finder')
      assert_equal [], empty_rule.send(:find_by_klass)      
    end
    
    test 'find_by_klass method finds objects of rules class using klass_method with params.' do
      foo1 = Foo.create
      foo2 = Foo.create
      rule1 = create(:rule, klass_name: 'Foo', klass_finder_method: 'take', method_params: 1)
      assert_equal [foo1], rule1.send(:find_by_klass)      
    end
    
    test 'find_undelivered_by_klass finds unprocessed objects using klass_method. works with both AR relations and arrays' do
      foo1 = Foo.create
      rule1 = create(:rule, klass_name: 'Foo', klass_finder_method: 'active_record_finder')
      rule2 = create(:rule, klass_name: 'Foo', klass_finder_method: 'array_finder')
      
      
      assert_equal [foo1], rule1.process
      assert_equal [foo1], rule2.process
      
      foo2 = Foo.create
      
      assert_equal [foo2], rule1.reload.send(:find_undelivered_by_klass)      
      assert_equal [foo2], rule2.reload.send(:find_undelivered_by_klass)      
      
    end
    
    
    
    test 'creates deliveries ONCE for objects matching class rule' do
      Foo.create
      rule = create(:rule, klass_name: 'Foo', klass_finder_method: 'active_record_finder')
      
      assert_difference 'Delivery.count' do
        rule.process
      end
      
      assert_no_difference 'Delivery.count' do
        rule.process
      end
    end
    
    test 'finds delivered objects where the condition no longer applies and resets them' do
      foo = Foo.create(active: true)
      rule = create(:rule, klass_name: 'Foo', klass_finder_method: 'active_finder')
      rule.process
      
      assert rule.send(:find_undelivered_by_klass).empty?
      assert_no_difference 'Delivery.count' do
         rule.process
       end
      
      foo.update_attributes(active: false)
      
      assert_difference 'Delivery.count', -1 do
        rule.clear_non_applicable_deliveries
      end
      
      foo.update_attributes(active: true)
      
      assert_difference 'Delivery.count' do
        rule.process
      end      
      
    end
    
    test "won't let you create a rule with an invalid class or method name" do
      assert_raises ActiveRecord::RecordInvalid do
        create(:rule, klass_name: 'Invalid', klass_finder_method: 'active_finder')
      end
      assert_raises ActiveRecord::RecordInvalid do
        create(:rule, klass_name: 'Foo', klass_finder_method: 'invalid')
      end
    end
    
  end
end
