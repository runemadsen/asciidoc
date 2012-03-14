plugin = {
  :name => :title2,
	:regexp  => /^=== +(?<title2>[\S].*?)( +===)?$/,
	:handler => lambda { |lines, element, counter|
    title = AsciiDoc::AsciiElement.new(plugin[:name])
    title.attributes[:count] = counter.increment(plugin[:name])
    title.attributes[:chapter_count] = counter.count(:title1)
    name = lines.current_line.gsub!(plugin[:regexp], '\k<title2>')
    title.attributes[:href] = name.gsub(" ", "-").downcase
    title.children << name
    element.children << title
	}
}

AsciiDoc::AsciiPlugins::register(plugin)