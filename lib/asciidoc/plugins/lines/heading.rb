plugin = {
  :name => :heading,
  :regexp => /^\w+/,
  :handler => lambda { |lines, element, counter|
  
    # TODO: Regex should use lines size to determine how many === are needed
    unless lines.next_line =~ /^={3,}$/
      return false
    end
    
    heading = AsciiDoc::AsciiElement.new(plugin[:name])
    heading.children << lines.current_line
    element.children << heading
    
    lines.shift_line
    lines.shift_line
}
}

AsciiDoc::AsciiPlugins::register(plugin)