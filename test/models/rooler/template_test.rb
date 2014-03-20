require 'test_helper'

module Rooler
  class TemplateTest < ActiveSupport::TestCase
    
    test "finds an object from one of the templates rules" do
      rule = create(:rule, klass_name: 'Foo', klass_finder_method: 'active_record_finder')
      assert_nil rule.template.test_object
      
      foo1 = Foo.create
      foo2 = Foo.create
      # puts rule.template.reload.test_object
      assert_equal foo1, rule.template.test_object
    end
  end
end
