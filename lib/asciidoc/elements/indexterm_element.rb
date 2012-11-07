module AsciiDoc
  
  class IndextermElement < AsciiElement
    
    attr_accessor :primary, :secondary, :link_id
    
    def parse(xml)
      @type = :indexterm
      @primary =  node_content(xml, "primary")
      @secondary =  node_content(xml, "secondary")
      @link_id = index_term_id
    end
    
    def index_term_id
      @primary.downcase.gsub(" ", "-") + (@secondary ? "-" + @secondary.downcase.gsub(" ", "-") : "") + "-" + UUID.new.generate
    end
    
    def to_hash
      {
        :link_ids => [@link_id],
        :children => {}
      }
    end
    
  end
  
end