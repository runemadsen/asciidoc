module AsciiDoc
  module AttributesHelper
   
    # parses a string of attributes into a hash
    # string must look like this: "key=value,key=value"
    def self.parse_attributes(attributes_string)
      parsed = {}
      values = attributes_string.split(",")
      values.each_with_index do |value, i|
        split = value.split("=")
        
        split[0].strip! # remove whitespace in key
        
        if split.size == 1
          split << split[0]
          split[0] = i
        else
          # remove double quotes around string
        end
        
        parsed[split[0]] = split[1]
      end
      parsed
    end
    
  end
end