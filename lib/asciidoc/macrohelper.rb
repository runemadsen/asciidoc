module AsciiDoc
  module MacroHelper
   
    # parses a string of attributes into a hash
    # string must look like this: "key=value,key=value"
    def self.parse_attributes(attributes_string, nokey = "nokey")
      parsed = {}
      values = attributes_string.split(",")
      values.each do |value|
        split = value.split("=")
        
        if split.size == 1
          split << split[0]
          split[0] = nokey
        end
        
        parsed[split[0]] = split[1]
      end
      parsed
    end
    
  end
end