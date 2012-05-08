require 'nokogiri'
require 'posix/spawn'
require 'erb'

module AsciiDoc
  
  class AsciiDocument
  
    attr_accessor :element

    def initialize(file_or_raw_asciidoc)
      if file_or_raw_asciidoc =~ /\.txt|\.asciidoc|\.asc/
        @xml = `asciidoc -b docbook45 -o - "#{File.expand_path(file_or_raw_asciidoc)}"`
      else
        @xml = POSIX::Spawn::Child.new('asciidoc -b docbook45 -o - -', :input => file_or_raw_asciidoc).out
      end
      parse_xml
    end
    
    def render(format, args = {})
      case format
      when :html
        render_html(args)
      when :pdf
        render_pdf(args)
      else
        raise "Bad Render Format Specified"
      end
    end
  
    private
    
    #  Parsing
    # ----------------------------------------------------------------
    
    def parse_xml
      @xml_doc = Nokogiri::XML(@xml) do |config|
        config.noblanks
      end
      @element = AsciiDoc::AsciiElement.new(@xml_doc.root)
    end
    
    #  Specific Render Functions
    # ----------------------------------------------------------------
    
    def render_html(args)
      
      views = {}
      
      # require default views
      Dir[File.dirname(__FILE__) + "/views/*.html.erb"].each { |file|
        symbol = file.split("/").last.split(".").first.to_sym
        views[symbol] = ERB.new(open(file).read)
      }
      
      # override with custom views
      if args[:template]
        Dir["./#{args[:template]}/*.html.erb"].each { |file| 
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
      if args[:layout] == false
        result = element.render_children(views, filter_results)
      else
        result = element.render(views, filter_results)
      end
      
      # return html or output to file
      if args[:output]
        FileUtils.mkdir_p(File.dirname(args[:output])) 
        File.open(args[:output], 'w') {|f| f.write(result) }
        args[:output]
      else
        result
      end
    end
    
    def render_pdf(args)
       Dir.mkdir("./#{args[:output]}") unless File.exists?("./#{args[:output]}")
       file_path = render_html(args)
       output_path = "#{args[:output]}/index.pdf"
       
       if args
         args = args.map { |hash| " #{hash[:option]} #{hash[:value]}" }.join
       else
         args = ""
       end
       
       `bin/wkhtmltopdf-0.9 #{file_path} #{output_path}#{args}`
       FileUtils.rm_rf "./#{output}/temp"
       "#{args[:output]}/index.pdf"
    end
  
  end
  
end