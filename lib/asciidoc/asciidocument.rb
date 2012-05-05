require 'nokogiri'

module AsciiDoc
  
  class AsciiDocument
  
    attr_accessor :element

    def initialize(file)
      @xml = `asciidoc -b docbook45 -o - "#{File.expand_path(file)}"`
      puts "----------- START XML -----------"
      puts @xml
      puts "----------- END XML ------------"
      parse_xml
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
    
    #  Parsing
    # ----------------------------------------------------------------
    
    def parse_xml
      @xml_doc = Nokogiri::XML(@xml)
      @element = AsciiDoc::AsciiElement.new(@xml_doc.root)
    end
    
    #  Specific Render Functions
    # ----------------------------------------------------------------
    
    def render_html(template_folder, output_folder, args = nil)
      
      # require all views
      views = {}
      Dir["./#{template_folder}/views/*.html.erb"].each { |file| 
        symbol = file.split("/").last.split(".").first.to_sym
        views[symbol] = ERB.new(open(file).read)
      }
      
      # run all filters
      # filters = AsciiDoc::Filters.constants
      filter_results = {}
      #       filters.each do |class_name|
      #         filter_results[class_name.downcase.to_sym] = AsciiDoc::Filters.const_get(class_name).filter(element.children)
      #       end
      
      # render everything.
      # raise Exception, "Main Document template file doesn't exist" if views[:document].nil?
      #       document = self
      result = element.render(views, filter_results)
      
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
  
  end
  
end