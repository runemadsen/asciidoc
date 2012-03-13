plugin = {
  :name => :table,
  :regexp  => /^(\.(?<title>.+)|\[(?<attrlist>.+)\]|(\|(=+)))$/,
	:handler => lambda { |lines, element, counter|
	  
	  # tables can start with either a heading, an attribute list or just the table header. This regex looks for them all,
	  # and we have these crazy if statements to check which one was triggered.
	  
	  # first return false if there's not a table in next 2 lines
	  return false unless (lines.next_line =~ /^(\|(=+))$/ || lines.nth_line(2) =~ /^(\|(=+))$/)
	  
	  table = AsciiDoc::AsciiElement.new(:table)
	  
	  # get title and macro elements before first table header
	  while(!(lines.current_line =~ /^(\|(=+))$/))
	    matchdata = plugin[:regexp].match(lines.current_line)
	    if matchdata["title"]
	      table.attributes = { :title => matchdata["title"]}
	    elsif matchdata["attrlist"]
	      puts "Save metadata: #{matchdata["attrlist"]}"
	    end
	    lines.shift_line
	  end
	  
	  # get rid of first table header
	  lines.shift_line
	  
	  # get all rows until last table header
	  body = ""
	  while(!(lines.current_line =~ /^(\|(=+))$/))
	    tr = AsciiDoc::AsciiElement.new(:tr)
	    values = lines.current_line.split("|")
	    values.map { |val| 
	      td = AsciiDoc::AsciiElement.new(:td) 
	      td.children << val.strip
	      tr.children << td
	    }
	    table.children << tr
	    lines.shift_line
	  end	  

    element.children << table
	}
}

AsciiDoc::AsciiPlugins::register(plugin)