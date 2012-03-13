plugin = {
  :name => :title1,
	:regexp  => /^== +(?<title1>[\S].*?)( +==)?$/,
	:handler => lambda { |lines, element, counter|
    title = AsciiDoc::AsciiElement.new(plugin[:name])
    title.attributes[:count] = counter.increment(plugin[:name])
    title.children << lines.current_line.gsub!(plugin[:regexp], '\k<title1>')
    element.children << title
	}
}

AsciiDoc::AsciiPlugins::register(plugin)