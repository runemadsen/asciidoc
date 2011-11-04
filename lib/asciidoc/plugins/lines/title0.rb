plugin = {
  :name => :title1,
	:regexp  => /^===== +(?<title0>[\S].*?)( +=====)?$/,
	:handler => lambda { |lines, element|
    title = AsciiElement.new(plugin[:name])
    title.children << lines.current_line.gsub!(plugin[:regexp], '\k<title0>')
    element.children << title
	}
}

AsciiPlugins::register(plugin)