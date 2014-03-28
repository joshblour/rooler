require 'test_helper'
require 'rubytree'

module Rooler
  class TemplateTest < ActiveSupport::TestCase
    
    test "finds an object from one of the templates rules" do
      rule = create(:rule, klass_name: 'Foo', klass_finder_method: 'active_record_finder')
      assert_nil rule.template.test_object
      
      foo1 = Foo.create
      foo2 = Foo.create
      assert_equal foo1, rule.template.test_object
    end
    
    test 'returns a tree of liquid methods from the sample object' do
      rule = create(:rule, klass_name: 'Foo', klass_finder_method: 'active_record_finder')
      foo = Foo.create
      
      tree = ::Tree::TreeNode.new("foo") 
      tree << ::Tree::TreeNode.new('active')
      tree << ::Tree::TreeNode.new('created_at')
      tree << ::Tree::TreeNode.new('bars')
      tree["bars"] << ::Tree::TreeNode.new("test")
      tree["bars"] << ::Tree::TreeNode.new("raboof")
      tree["bars"] << ::Tree::TreeNode.new("foo")
      tree["bars"]["raboof"] << ::Tree::TreeNode.new('test')
      tree["bars"]["raboof"] << ::Tree::TreeNode.new('updated_at')
            
      assert_equal tree.to_json, rule.template.liquid_method_tree.to_json
    end
  end
end
