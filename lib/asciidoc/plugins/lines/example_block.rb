plugin = {
  :name => :example_block,
  :regexp  => /^\[(?<attrlist>.+)\]$/,
	:handler => lambda { |lines, element|
    
    attributes = AsciiDoc::AttributesHelper.parse_attributes(lines.current_line.gsub(plugin[:regexp], '\k<attrlist>'))
    
    lines.shift_line
    
    # TODO: Make it possible to have .My Block Title after the attributeslist
    
    # If there's a title for this block
    if lines.current_line =~ /^\.(?<title>.+)/
      attributes[:title] = lines.current_line[1..-1]
      lines.shift_line
    elsif lines.current_line !=~ /^={3,}$/
      return false
    end
    
    body = ""
    
    while(lines.shift_line) do
      break if lines.current_line =~ /^={3,}$/
      body += lines.current_line
      body += "\n"
    end
    
    block = AsciiDoc::AsciiElement.new(attributes[0].to_sym)
    block.children << body
    block.attributes = attributes
    element.children << block
	}
}

AsciiDoc::AsciiPlugins::register(plugin)