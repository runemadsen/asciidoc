module AsciiDoc
  
  class TableElement < AsciiElement
    
    def parse(xml)
      @header = xml.at_xpath("//thead//row").children.map do |entry|
        entry.content
      end
      
      @rows = xml.xpath("//tbody//row").map do |row|
        row.children.map do |entry|
          entry.content
        end
      end
      
      @footer = xml.at_xpath("//tfoot//row").children.map do |entry|
        entry.content
      end
      
    end
  end
end