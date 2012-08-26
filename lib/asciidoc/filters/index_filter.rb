module AsciiDoc
  module Filters
    class IndexFilter
      
      def self.filter(element)
        hie = []
        find_index_terms_in_children(element, hie) 
        hie
      end
      
      def self.find_index_terms_in_children(element, hie)
        element.children.each do |child|
          puts child.type
          if child.type == :indexterm
            hie << child.to_hash
          end
          if child.children
            find_index_terms_in_children(child, hie)
          end
        end
      end
      
    end
  end
end