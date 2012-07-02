module AsciiDoc
  module Filters
    
    # This filter runs through all the elements and converts their type from :title to one of h1, h2, h3, h4, h5, h6
    # This is because docbook has no level indication on <title>, instead it relies on nested <section> tags
    
    class TitleFilter
      def self.filter(element)
        find_title_in_children(element, 2)
      end
      
      def self.find_title_in_children(element, level)
        element.children.each do |child|          
          if child.type == :title
            child.type = "h#{level}".to_sym
          end
          if child.children
            step_up = [:section, :admonition].include?(child.type)
            find_title_in_children(child, step_up ? level + 1 : level)
          end
        end
      end
    end
  end
end