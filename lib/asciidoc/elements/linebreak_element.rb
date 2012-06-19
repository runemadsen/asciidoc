module AsciiDoc
  
  class LinebreakElement < AsciiElement
    
    def render(views, filter_results)
      "<br />"
    end
     
  end
  
end