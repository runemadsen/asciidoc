module AsciiDoc
  
  class SourceElement < AsciiElement
    
    def parse(xml)
      @type = :source
      @content = xml.content
    end
    
  end
  
end