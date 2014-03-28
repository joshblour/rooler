module Rooler
  module ApplicationHelper
    
    def liquidize(content, arguments)
      Liquid::Template.parse(content).render(arguments, :filters => [Rooler::LiquidFilters]).html_safe
    end
    
    def render_tree(tree)
      res = "<ul>"
      res << "<li>#{tree.name}"
      tree.children.each {|child| res << render_tree(child)}
      res << "</li></ul>"
      res
    end
     
  end
end
