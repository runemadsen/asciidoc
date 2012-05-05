module AsciiDoc
  
  class MediaElement < AsciiElement
    
    def parse(xml)
      @type = :img
      @src = xml.at_xpath("//imageobject//imagedata").attribute("fileref")
      @alt = node_content(xml, "textobject//phrase")
    end
    
  end
  
end