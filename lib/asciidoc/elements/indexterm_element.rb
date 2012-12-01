module AsciiDoc
  
  class IndextermElement < AsciiElement
    
    attr_accessor :primary, :secondary, :link_id
    
    def parse_metadata(xml)
      @type = :indexterm
      @attributes = xml.attributes
      @primary =  node_content(xml, "primary")
      @secondary =  node_content(xml, "secondary")
      @link_id = index_term_id
    end
    
    def index_term_id
      @primary.downcase.gsub(" ", "-") + (@secondary ? "-" + @secondary.downcase.gsub(" ", "-") : "") + "-" + UUID.new.generate
    end
    
    def to_hash
      {
        :elements => [self],
        :children => {},
      }
    end
    
  end
  
end