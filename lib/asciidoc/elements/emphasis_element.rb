module AsciiDoc
  
  class EmphasisElement < AsciiElement
    
    def parse_metadata(xml)
            
      @attributes = xml.attributes
      
      # if only child is a phrase element with a role attribute, make generative span class
      # this is used for strike-through, etc. role attribute will be added as span class name
      if xml.children.size == 1 && xml.children.first.name == "phrase" && xml.children.first.attributes["role"]
        @type = :span
        @attributes = @attributes.merge(xml.children.first.attributes)
      # else make bold or italic
      else
        @type = xml.attributes["role"].nil? ? :italic : :strong
      end
      
    end
    
  end
  
end