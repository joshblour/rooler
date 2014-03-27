module Rooler
  class LiquidInspector
    
    def initialize(klass)
      @klass = klass.to_s.downcase
    end
    
    def tree
      add_liquid_methods_as_nodes(::Tree::TreeNode.new(@klass))
    end

    private
      
    # Recursive method. Infers a class name using the name of the provided TreeNode. Creates nodes any liquid methods belonging to that class. If any of those nodes
    # are also associations, it calls itself on that node.
    def add_liquid_methods_as_nodes(tree)
      klass = tree.name.to_s.classify.constantize
      add_nodes_to_tree(tree, liquid_methods(klass))
      (associations(klass) & liquid_methods(klass)).each do |node|
        add_liquid_methods_as_nodes(tree[node])
      end
      return tree
    end
    
    def add_nodes_to_tree(tree, nodes)
      nodes.each {|node| tree << ::Tree::TreeNode.new(node)}
    end
    
    def associations(klass)
      klass.reflect_on_all_associations.map(&:name)
    end
    
    def liquid_methods(klass)
      klass::LiquidDropClass.public_instance_methods - Liquid::Drop.public_instance_methods
    end
    
  end
end