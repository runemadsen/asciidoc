module AsciiDoc
  module Filters
    
    # This filter runs through all the elements and creates an :anchor element if the tag has an id attribute
    # this way we don't need to do this in all the views
    
    class AnchorFilter
      def self.filter(element)
        find_id_in_children(element)
      end
      
      def self.find_id_in_children(element)
        element.children.each_with_index do |child, i|
          if child.attributes["id"]
            child.children.insert(0, AnchorElement.new(child.attributes["id"]))
          end
          if child.children
            find_id_in_children(child)
          end
        end
      end
    end
  end
end