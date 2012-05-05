require 'nokogiri'

module AsciiDoc
  
  class AsciiDocument
  
    attr_accessor :element

    def initialize(file)
      @xml = `asciidoc -b docbook45 -o - "#{File.expand_path(file)}"`
      parse_xml
    end
    
    def render(format, template_folder = nil, output_file = nil, args = nil)
      case format
      when :html
        render_html(template_folder, output_file, args)
      when :pdf
        render_pdf(template_folder, output_file, args)
      else
        raise "Bad Render Format Specified"
      end
    end
  
    private
    
    #  Parsing
    # ----------------------------------------------------------------
    
    def parse_xml
      @xml_doc = Nokogiri::XML(@xml)
      @element = AsciiDoc::AsciiElement.new(@xml_doc.root)
    end
    
    #  Specific Render Functions
    # ----------------------------------------------------------------
    
    def render_html(template_folder, output_file, args)
      
      views = {}
      
      # require default views
      Dir[File.dirname(__FILE__) + "/views/*.html.erb"].each { |file|
        symbol = file.split("/").last.split(".").first.to_sym
        views[symbol] = ERB.new(open(file).read)
      }
      
      # override with custom views
      if template_folder
        Dir["./#{template_folder}/*.html.erb"].each { |file| 
          symbol = file.split("/").last.split(".").first.to_sym
          views[symbol] = ERB.new(open(file).read)
        }
      end
      
      # run all filters
      filters = AsciiDoc::Filters.constants
      filter_results = {}
      filters.each do |class_name|
        filter_results[class_name.downcase.to_sym] = AsciiDoc::Filters.const_get(class_name).filter(element)
      end
    
      # render the html
      result = element.render(views, filter_results)
      
      # return html or output to file
      if output_file
        FileUtils.mkdir_p(File.dirname(output_file)) 
        File.open(output_file, 'w') {|f| f.write(result) }
        output_file
      else
        result
      end
    end
    
    def render_pdf(template_folder, output_folder, args)
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
  
  end
  
end