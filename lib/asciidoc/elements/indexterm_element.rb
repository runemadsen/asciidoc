module AsciiDoc
  
  class IndextermElement < AsciiElement
    
    def parse(xml)
      @primary =  node_content(xml, "primary")
      @secondary =  node_content(xml, "secondary")
      @link_id = index_term_id
    end
    
    # problem: same index tag creates the same id
    def index_term_id
      @primary.downcase.gsub(" ", "-") + (@secondary ? "-" + @secondary.downcase.gsub(" ", "-") : "")
    end
    
  end
  
end