module AsciiDoc
  
  class ListElement < AsciiElement
    
    def parse_metadata(xml)
      @type = xml_to_view_name(xml.name.to_sym)
      @style = xml.attribute("numeration")
      @attributes = xml.attributes
    end
    
  end
  
end