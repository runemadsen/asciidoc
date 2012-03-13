plugin = {
  :name => :paragraph,
	:regexp  =>  /^\w+/,
	:handler => lambda { |lines, element, counter|
    
    body = lines.current_line
    
    while(lines.shift_line) do
      break if lines.current_line =~ /^\s*$/
      body += lines.current_line
    end

    paragraph = AsciiDoc::AsciiElement.new(plugin[:name])
    paragraph.children << body
    element.children << AsciiDoc::AsciiBlock.new(paragraph).element
	}
}

AsciiDoc::AsciiPlugins::register(plugin)