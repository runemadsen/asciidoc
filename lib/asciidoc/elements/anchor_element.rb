module AsciiDoc
  
  class AnchorElement < AsciiElement
    
    def initialize(name)
      @attributes = {}
      @type = :anchor
      @name = name
    end
    
  end
  
end