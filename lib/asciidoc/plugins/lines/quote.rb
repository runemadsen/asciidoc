plugin = {
  :name => :quote,
	:regexp  => /^\[quote\]$/,
	:handler => lambda { |lines, element, counter|
    
    body = ""
    
    while(lines.shift_line) do
      break if lines.current_line =~ /^\s*$/
      body += lines.current_line
    end
    
    quote = AsciiDoc::AsciiElement.new(plugin[:name])
    quote.children << body
    element.children << quote
    
	}
}

AsciiDoc::AsciiPlugins::register(plugin)