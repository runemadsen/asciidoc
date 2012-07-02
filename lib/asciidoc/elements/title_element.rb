module AsciiDoc
  
  class TitleElement < AsciiElement
    
    def parse(xml)
      @attributes["id"] = slug(xml.content)
      @content = xml.content
    end
    
  end
  
end