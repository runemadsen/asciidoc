plugin = {
  :name => :quote,
	:regexp  => /^\[quote(,\s?)(?<author>.+)\]$/,
	:handler => lambda { |lines, element, counter|
    
    # right now quotes only work if you specify an author
    author = lines.current_line.gsub(plugin[:regexp], '\k<author>')
    lines.shift_line # get rid of [quote]
    
    body = ""
    
    while(lines.shift_line) do
      break if lines.current_line =~ /^_+$/
      body += lines.current_line
    end
    
    puts "Quote body:"
    puts body
    
    quote = AsciiDoc::AsciiElement.new(plugin[:name])
    quote.attributes[:author] = author
    quote.children << body
    element.children << quote
    
	}
}

AsciiDoc::AsciiPlugins::register(plugin)