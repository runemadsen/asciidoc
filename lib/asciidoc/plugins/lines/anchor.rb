plugin = {
  :name => :anchor,
	:regexp  => /^<<(?<attrlist>.{1,})>>$/,
	:handler => lambda { |lines, element|
    anchor = AsciiDoc::AsciiElement.new(plugin[:name])
    anchor.attributes = AsciiDoc::AttributesHelper.parse_attributes(lines.current_line.gsub(plugin[:regexp], '\k<attrlist>'))
    element.children << anchor
	}
}

AsciiDoc::AsciiPlugins::register(plugin)