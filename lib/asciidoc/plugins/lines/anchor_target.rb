plugin = {
  :name => :anchor_target,
	:regexp  => /^\[\[(?<attrlist>.{1,})\]\]$/,
	:handler => lambda { |lines, element|
    anchor_target = AsciiDoc::AsciiElement.new(plugin[:name])
    anchor_target.attributes = AsciiDoc::AttributesHelper.parse_attributes(lines.current_line.gsub(plugin[:regexp], '\k<attrlist>'))
    element.children << anchor_target
	}
}

AsciiDoc::AsciiPlugins::register(plugin)