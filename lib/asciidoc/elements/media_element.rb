module AsciiDoc
  
  class MediaElement < AsciiElement
    
    def parse(xml)
      @type = :img
      @src = xml.at_xpath(".//imageobject//imagedata").attribute("fileref")
      @alt = node_content(xml, "textobject//phrase")
    end
    
    def parse_metadata(xml)
      @type = xml.name.to_sym
      @attributes = xml.attributes
      @attributes = @attributes.merge(xml.at_xpath(".//imageobject//imagedata").attributes)
    end
    
  end
  
end