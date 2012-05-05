module AsciiDoc
  
  # This element parses the <articleinfo> tag. It takes the info and puts into vars, that are not outputted in the 
  # document because they are not in the children array, nor has a custom view template.
  
  class InfoElement < AsciiElement
    
    def parse(xml)
      @date = node_content(xml, "date")
    end
    
  end
  
end