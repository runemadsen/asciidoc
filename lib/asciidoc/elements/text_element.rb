module AsciiDoc
  
  class TextElement < AsciiElement
    
    def parse(xml)
      @content = xml.content
    end
    
    # override render because a text element has no children, nor any views attached to it.
    # it's just pure text
    def render(views, filter_results)
      @content
    end
    
  end
  
end