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
            
            if hie[child.primary]
              hie[child.primary][:link_ids] << child.link_id unless child.secondary
            else
              hie[child.primary] = child.to_hash unless child.secondary
            end
            
            if child.secondary
              if hie[child.secondary]
                if hie[child.secondary][:children][child.primary]
                  hie[child.secondary][:children][child.primary][:link_ids] << child.link_id
                else
                  hie[child.secondary][:children][child.primary] = child.to_hash
                end
              else
                hie[child.secondary] = child.to_hash
                hie[child.secondary][:children][child.primary] = child.to_hash
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