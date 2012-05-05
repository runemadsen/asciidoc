module AsciiDoc
  
  class TitleElement < AsciiElement
    
    def parse(xml)
      @content = xml.content
    end
    
  end
  
end