plugin = {
  :name => :italic,
	:regexp  =>  /_/,
	:handler => lambda { |chars, element|
    
    if not chars.next_char =~ /\S/
      return false
    end
    
    body = ""
    
    while(chars.shift_char) do
      break if chars.current_char =~ /_/
      body += chars.current_char
    end

    italic = AsciiDoc::AsciiElement.new(plugin[:name])
    italic.children << body
    element.children << AsciiDoc::AsciiBlock.new(italic).element 
	}
}

AsciiDoc::AsciiCharPlugins::register(plugin)