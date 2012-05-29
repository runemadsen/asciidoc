module AsciiDoc
  
  class AdmonitionElement < AsciiElement
    
    def parse_metadata(xml)
      @type = :admonition
      @admonition = xml.name.to_sym
      @attributes = xml.attributes
    end
    
  end
  
end