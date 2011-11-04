plugin = {
  :name => :bold,
	:regexp  =>  /\*/,
	:handler => lambda { |chars, element|
    
    if not chars.next_char =~ /\S/
      return false
    end
    
    body = ""
    
    while(chars.shift_char) do
      break if chars.current_char =~ /\*/
      body += chars.current_char
    end

    bold = AsciiDoc::AsciiElement.new(plugin[:name])
    bold.children << body
    element.children << AsciiDoc::AsciiBlock.new(bold).element 
	}
}

AsciiDoc::AsciiCharPlugins::register(plugin)