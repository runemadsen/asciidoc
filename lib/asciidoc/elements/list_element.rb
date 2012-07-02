module AsciiDoc
  
  class ListElement < AsciiElement
    
    def parse_metadata(xml)
      
      # get title and delete it so it's not a part of list
      title = xml.css("title").first
      if title
        @title = title.children.first.to_s
        xml.css("title").first.remove if @title
      end
      
      @type = xml_to_view_name(xml.name.to_sym)
      @style = xml.attribute("numeration")
      @attributes = xml.attributes
    end
    
  end
  
end