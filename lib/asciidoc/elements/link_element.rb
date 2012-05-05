module AsciiDoc
  
  class LinkElement < AsciiElement
    
    def parse(xml)
      @href = xml.attribute("linkend")
      @content = xml.content
    end
    
  end
  
end