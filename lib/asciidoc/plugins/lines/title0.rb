plugin = {
  :name => :title1,
	:regexp  => /^===== +(?<title0>[\S].*?)( +=====)?$/,
	:handler => lambda { |lines, element, counter|
    title = AsciiDoc::AsciiElement.new(plugin[:name])
    title.attributes[:count] = counter.increment(p[:name])
    name = lines.current_line.gsub!(plugin[:regexp], '\k<title0>')
    title.attributes[:href] = name.gsub(" ", "-").downcase
    title.children << name
    element.children << title
	}
}

AsciiDoc::AsciiPlugins::register(plugin)