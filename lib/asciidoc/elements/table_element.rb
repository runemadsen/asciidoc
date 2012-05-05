module AsciiDoc
  
  class TableElement < AsciiElement
    
    def parse(xml)
      
      # parse header
      @header = xml.xpath(".//thead//row//entry").map do |entry|
        entry.content
      end
      
      # parse body
      @rows = xml.xpath(".//tbody//row").map do |row|
        row.xpath(".//entry").map do |entry|
          entry.content
        end
      end

      # parse footer      
      @footer = xml.xpath(".//tfoot//row//entry").map do |entry|
        entry.content
      end
      
    end
  end
end