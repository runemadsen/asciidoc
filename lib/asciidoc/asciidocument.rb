module AsciiDoc
  
  class AsciiDocument
  
    include AsciiDoc::AsciiPlugins

    def initialize(content)
      @element = AsciiDoc::AsciiElement.new(:document)
      @lines = AsciiDoc::AsciiLines.new(content)
      parse_lines
    end
    
    def render(format, template_folder, output_folder)
      case format
      when :html
        render_html(template_folder, output_folder)
      when :pdf
        render_pdf(template_folder, output_folder)
      else
        raise "Bad Render Format Specified"
      end
    end
  
    private
    
    #  Specific Render Functions
    # ----------------------------------------------------------------
    
    def render_html(template_folder, output_folder)
      views = {}
      Dir["./#{template_folder}/views/*.html.erb"].each { |file| 
        symbol = file.split("/").last.split(".").first.to_sym
        views[symbol] = ERB.new(open(file).read)
      }
      result = @element.render(views)
      
      # if output folder does not exist, create it
      Dir.mkdir("./#{output_folder}") unless File.exists?("./#{output_folder}")
      
      # render html into index.html file
      html = File.new("./#{output_folder}/index.html", "w+")
      html.puts(result)
      
      # copy all content in /public to the output folder
      FileUtils.cp_r "./#{template_folder}/public/.", "./#{output_folder}"
      
      "#{output_folder}/index.html"
    end
    
    def render_pdf(template_folder, output_folder)
       Dir.mkdir("./#{output_folder}") unless File.exists?("./#{output_folder}")
       file_path = render_html(template_folder, "#{output_folder}/temp")
       output_path = "#{output_folder}/index.pdf"
       `wkhtmltopdf #{file_path} #{output_path}`
       FileUtils.rm_rf "./#{output_folder}/temp"
       "#{output_folder}/index.pdf"
    end
  
    def parse_lines
      order_plugins
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