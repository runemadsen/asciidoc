module AsciiDoc
  
  class AsciiDocument
  
    include AsciiDoc::AsciiPlugins

    def initialize(file)
      content = open(file).read
      
      # include all asciidoc files
      path = File.split(file)
      content = content.gsub(/^include::(.+)\[(.?)\]$/) do |match| 
        open(File.join(path[0], $1)).read
      end
      
      @element = AsciiDoc::AsciiElement.new(:document)
      @lines = AsciiDoc::AsciiLines.new(content)
      parse_lines
    end
    
    def render(format, template_folder, output_folder, args = nil)
      case format
      when :html
        render_html(template_folder, output_folder, args)
      when :pdf
        render_pdf(template_folder, output_folder, args)
      else
        raise "Bad Render Format Specified"
      end
    end
  
    private
    
    #  Specific Render Functions
    # ----------------------------------------------------------------
    
    def render_html(template_folder, output_folder, args = nil)
      views = {}
      Dir["./#{template_folder}/views/*.html.erb"].each { |file| 
        symbol = file.split("/").last.split(".").first.to_sym
        views[symbol] = ERB.new(open(file).read)
      }
      result = @element.render(views)
      
      # if output folder does not exist, create it
      Dir.mkdir("./#{output_folder}") unless File.exists?("./#{output_folder}")
      
      # render html into index.html file
      File.open("./#{output_folder}/index.html", 'w') {|f| f.write(result) }
      
      # copy all content in /public to the output folder
      FileUtils.cp_r "./#{template_folder}/public/.", "./#{output_folder}"
      
      "#{output_folder}/index.html"
    end
    
    def render_pdf(template_folder, output_folder, args = nil)
       Dir.mkdir("./#{output_folder}") unless File.exists?("./#{output_folder}")
       file_path = render_html(template_folder, "#{output_folder}/temp")
       output_path = "#{output_folder}/index.pdf"
       
       if args
         args = args.map { |hash| " #{hash[:option]} #{hash[:value]}" }.join
       else
         args = ""
       end
       
       `bin/wkhtmltopdf-0.9 #{file_path} #{output_path}#{args}`
       FileUtils.rm_rf "./#{output_folder}/temp"
       "#{output_folder}/index.pdf"
    end
  
    def parse_lines
      detect_plugins
      while @lines.shift_line do
        unless @lines.current_line =~ /^\s*$/
          detect_plugins
        end
      end
    end
  
    def detect_plugins()
      found = false
      Plugins.each do |p|
        if p[:regexp] =~ @lines.current_line
          if p[:handler].call(@lines, @element)
            found = true
            break
          end
        end
      end
      unless found
        @element.children << "NOT FOUND: " + @lines.current_line
      end
    end
  
  end
  
end