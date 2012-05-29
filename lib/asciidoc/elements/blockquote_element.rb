module AsciiDoc
  
  class BlockquoteElement < AsciiElement
    
    def parse(xml)
      @attribution = node_content(xml, "attribution")
      @quote = node_content(xml, "simpara")
    end
    
  end
  
end