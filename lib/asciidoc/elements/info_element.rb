module AsciiDoc
  
  # This element parses the <articleinfo> tag. It takes the info and puts into vars, that are not outputted in the 
  # document because they are not in the children array, nor has a custom view template.
  
  class InfoElement < AsciiElement
    
    def parse(xml)
      @date = node_content(xml, "date")
      @title = node_content(xml, "title")
      @autor = {
        :firstname => node_content(xml, "author//firstname"),
        :surname => node_content(xml, "author//surname"),
        :email => node_content(xml, "author//email")
      }
    end
    
    def parse_metadata(xml)
      @attributes = xml.attributes
      @type = :info
    end
    
  end
  
end