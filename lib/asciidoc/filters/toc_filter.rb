module AsciiDoc
  module Filters
    class TOCFilter
      
      def self.filter(element)
        hie = []
        find_titles_in_children(element, hie)
        
        # stupid hack because docbook creates this "preface" element with an empty title
        # for everythin that comes before the first chapter title
        hie.shift
        
        hie
      end
      
      def self.find_titles_in_children(element, hie)
        
        levels = [:h2, :h3]
        
        element.children.each do |child|
            
            if child.type == levels[0]
              hie << { :el => child, :children => [] }
            elsif child.type == levels[1]
              hie.last[:children] << { :el => child, :children => [] }
            end
            
            if child.children
              find_titles_in_children(child, hie)
            end
        end
        
      end
      
    end
  end
end