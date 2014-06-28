module Rooler
  class LiquidInspector
    
    def initialize(klass)
      @klass_name = klass.to_s.underscore
    end
    
    def tree
      tree = ::Tree::TreeNode.new(@klass_name.camelize.demodulize.underscore)
      add_liquid_methods_as_nodes(tree, @klass_name)
    end

    private
      
    # Recursive method. Creates nodes any liquid methods belonging to that class. If any of those nodes
    # are also associations, it calls itself on that node. Note the different (intential use of association.name and class_name)
    def add_liquid_methods_as_nodes(tree, klass_name)
      klass = klass_name.to_s.camelize.constantize
      add_nodes_to_tree(tree, liquid_methods(klass))
      associations(klass).each do |association|
        unless tree.parentage && tree.parentage.map {|p| p.name.to_s.classify}.include?(association.name.to_s.classify)
          add_liquid_methods_as_nodes(tree[association.name.to_sym], association.class_name)
        end
      end
      return tree
    end
    
    #iterate over nodes and add them to the tree. the << operator does not accept an array :(
    def add_nodes_to_tree(tree, nodes_names)
      nodes_names.each {|node| tree << ::Tree::TreeNode.new(node)}
    end
    
    #get associations haveing the same name as any liquid methods
    def associations(klass)
      liquid_methods = liquid_methods(klass)
      return klass.reflect_on_all_associations.select {|k| liquid_methods.include?(k.name.to_sym)}
    end
    
    
    def liquid_methods(klass)
      if klass.const_defined?('LiquidDropClass')
        return klass::LiquidDropClass.public_instance_methods.map(&:to_sym) - ::Liquid::Drop.public_instance_methods.map(&:to_sym)
      else
        return []
      end
    end
    
  end
end