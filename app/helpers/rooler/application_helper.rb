module Rooler
  module ApplicationHelper
    
    def liquidize(content, arguments)
      Liquid::Template.parse(content).render(arguments, :filters => [Rooler::LiquidFilters]).html_safe
    end
    
    def print_tree(tree)
      content_tag :ul do
        content_tag :li, tree.name
        tree.children { |child| print_tree(child) if child } # Child might be 'nil'
      end
    end
     
  end
end
