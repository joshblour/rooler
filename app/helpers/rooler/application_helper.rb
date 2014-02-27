module Rooler
  module ApplicationHelper
    
    def liquidize(content, arguments)
      Liquid::Template.parse(content).render(arguments, :filters => [Rooler::LiquidFilters]).html_safe
    end
     
  end
end
