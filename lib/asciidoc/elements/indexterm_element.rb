module AsciiDoc
  
  class IndextermElement < AsciiElement
    
    def parse(xml)
      @type = :indexterm
      @primary =  node_content(xml, "primary")
      @secondary =  node_content(xml, "secondary")
      @link_id = index_term_id
    end
    
    # problem: same index tag creates the same id
    def index_term_id
      @primary.downcase.gsub(" ", "-") + (@secondary ? "-" + @secondary.downcase.gsub(" ", "-") : "")
    end
    
    def to_hash
      {
        :primary => @primary,
        :secondary => @secondary,
        :link_id => @link_id
      }
    end
    
  end
  
end