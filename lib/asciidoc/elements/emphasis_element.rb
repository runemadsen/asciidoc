module AsciiDoc
  
  class EmphasisElement < AsciiElement
    
    def parse_metadata(xml)
      @type = xml.attributes["role"].nil? ? :italic : :bold
      @attributes = xml.attributes
    end
    
  end
  
end