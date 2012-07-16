module AsciiDoc
  
  class TitleElement < AsciiElement
    
    attr_reader :content, :attributes # for TOC
    
    def parse(xml)
      @attributes["id"] = slug(xml.content)
      @content = xml.content
    end
    
  end
  
end