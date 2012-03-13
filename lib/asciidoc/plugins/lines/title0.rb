plugin = {
  :name => :title1,
	:regexp  => /^===== +(?<title0>[\S].*?)( +=====)?$/,
	:handler => lambda { |lines, element, counter|
    title = AsciiDoc::AsciiElement.new(plugin[:name])
    title.attributes[:count] = counter.increment(p[:name])
    title.children << lines.current_line.gsub!(plugin[:regexp], '\k<title0>')
    element.children << title
	}
}

AsciiDoc::AsciiPlugins::register(plugin)