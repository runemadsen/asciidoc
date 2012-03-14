plugin = {
  :name => :example_block,
  :regexp  => /^\[(?<attrlist>.+)\]$/,
	:handler => lambda { |lines, element, counter|
    
    attributes = AsciiDoc::AttributesHelper.parse_attributes(lines.current_line.gsub(plugin[:regexp], '\k<attrlist>'))
    
    # TODO: Make it possible to have .My Block Title after the attributeslist
    
    # If there's a title for this block
    if lines.next_line =~ /^\.(?<title>.+)/
      lines.shift_line
      attributes[:title] = lines.current_line[1..-1]
    elsif lines.next_line !=~ /^={3,}$/
      return false
    end
    
    lines.shift_line
    
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