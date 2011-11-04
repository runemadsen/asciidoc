plugin = {
  :name => :title1,
	:regexp  => /^== +(?<title1>[\S].*?)( +==)?$/,
	:handler => lambda { |lines, element|
    title = AsciiDoc::AsciiElement.new(plugin[:name])
    title.children << lines.current_line.gsub!(plugin[:regexp], '\k<title1>')
    element.children << title
	}
}

AsciiDoc::AsciiPlugins::register(plugin)