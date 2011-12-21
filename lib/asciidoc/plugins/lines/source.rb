plugin = {
  :order => 2,
  :name => :source,
	:regexp  => /^\[source,[a-z]+\]$/,
	:handler => lambda { |lines, element|
    
    lines.shift_line
    
    unless lines.current_line =~ /^-{3,}$/
      return false
    end
    
    body = ""
    
    while(lines.shift_line) do
      break if lines.current_line =~ /^-{3,}$/
      body += lines.current_line
      body += "\n"
    end
    
    source = AsciiDoc::AsciiElement.new(plugin[:name])
    source.children << "Java" # TODO: This should be dynamic
    source.children << body
    
    element.children << source
	}
}

AsciiDoc::AsciiPlugins::register(plugin)