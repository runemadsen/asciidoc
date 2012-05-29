module AsciiDoc
  
  class LinkElement < AsciiElement
    
    def parse(xml)
      @type = :link
      
      if xml.name == "link"
        @href = "#" + xml.attribute("linkend")
      else
        @href = xml.attribute("url")
      end
      @content = xml.content
    end
    
  end
  
end