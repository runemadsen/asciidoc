plugin = {
  :name => :macro,
  :order => 2,
  :regexp => /^(?<name>\w+):{1,2}(?<target>\S*)\[(?<attrlist>.*)\]$/,
	:handler => lambda { |lines, element, counter|   
    macro = AsciiDoc::AsciiElement.new(lines.current_line.gsub(plugin[:regexp], '\k<name>').to_sym)
    macro.children << lines.current_line.gsub(plugin[:regexp], '\k<target>')
    macro.attributes = AsciiDoc::AttributesHelper.parse_attributes(lines.current_line.gsub(plugin[:regexp], '\k<attrlist>'))
    element.children << macro
	}
}

AsciiDoc::AsciiPlugins::register(plugin)