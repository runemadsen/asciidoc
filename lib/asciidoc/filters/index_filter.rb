module AsciiDoc
  module Filters
    class IndexFilter
      
      def self.filter(element)
        hie = {}
        find_index_terms_in_children(element, hie)
        hie
      end
      
      def self.find_index_terms_in_children(element, hie)
        element.children.each do |child|
          
          if child.type == :indexterm
            
            # always create primary
            if hie[child.primary]
              hie[child.primary][:elements] << child
            else
              hie[child.primary] = child.to_hash
            end

            # if secondary is there, put in children
            if child.secondary
              if hie[child.primary][:children][child.secondary]
                hie[child.primary][:children][child.secondary][:elements] << child
              else
                hie[child.primary][:children][child.secondary] = child.to_hash
              end
            end
          end

          if child.children
            find_index_terms_in_children(child, hie)
          end

        end
      end
      
    end
  end
end