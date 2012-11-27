require 'nokogiri'
require 'posix/spawn'
require 'erb'
require 'shellwords'
require 'uuid'

module AsciiDoc

  class AsciiDocument

    attr_accessor :element, :xml

    def initialize(file_or_raw_asciidoc, args = {})
      if file_or_raw_asciidoc =~ /\.txt|\.asciidoc|\.asc$/
        @xml = `asciidoc -b docbook45 -d book -f "#{File.dirname(__FILE__) + "/override.conf"}" -o - "#{File.expand_path(file_or_raw_asciidoc)}"`
      else
        @xml = POSIX::Spawn::Child.new("asciidoc -b docbook45 -f '#{File.dirname(__FILE__) + "/override.conf"}' -o - -", :input => file_or_raw_asciidoc).out
      end

      if args[:debug_xml_to_file]
        File.open(args[:debug_xml_to_file], 'w') {|f| f.write(@xml) }
      end

      parse_xml
    end

    def render(format, args = {})
      case format
      when :html
        render_html(args)
      when :html_chapters
        render_html_chapters(args)
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

    #  Render HTML
    # ----------------------------------------------------------------

    def render_html(args)
      views = get_views(args[:template])
      filter_results = get_filter_results

      if args[:layout] == false
        result = element.render_children(views, filter_results)
      else
        result = element.render(views, filter_results)
      end

      # return html or output to file
      if args[:output]
        render_to_file(result, args[:output])
        args[:output]
      else
        result
      end
    end

    #  Render HTML Chapters
    # ----------------------------------------------------------------

    def render_html_chapters(args)

      views = get_views(args[:template])
      filter_results = get_filter_results

      # get all elements
      intro_children = element.children.find_all { |child| child.type == :info }
      chapter_children = element.children.find_all { |child| !intro_children.any? { |c| c.type == child.type} }

      # render index.html with toc
      element.children = intro_children
      intro_result = element.render(views, filter_results)
      render_to_file(intro_result, args[:output]) # render to index.html

      # go through each chapter element, put it in element as child, and render to chapter# file
      folder = File.dirname(args[:output])
      chapter_children.each_with_index { |chapter, i|
        element.children = [chapter]
        chapter_result = element.render(views, filter_results)
        doc = Nokogiri::HTML(chapter_result)
        h2 = doc.css('h2[id]')
        title = h2.length > 0 ? h2[0]['id'] : "chapter#{i}"
        render_to_file(chapter_result, File.join(folder, "book", "#{title}", "index.html")) # render to index.html
      }

      args[:output]

    end

    #  Render PDF
    # ----------------------------------------------------------------

    def render_pdf(args)
      raise Exception, "You need to specify an html file to render from when exporting to PDF" unless args[:html_file]
      FileUtils.mkdir_p(File.dirname(args[:output]))
      `prince --javascript #{Shellwords.escape(args[:html_file])} -o #{Shellwords.escape(args[:output])} -i html5`
      args[:output]
    end

    #  Helpers
    # ----------------------------------------------------------------

    def get_views(template_folder)
      views = {}
      # require default views
      Dir[File.dirname(__FILE__) + "/views/*.html.erb"].each { |file|
        symbol = file.split("/").last.split(".").first.to_sym
        views[symbol] = ERB.new(open(file).read)
      }
      # override with custom views
      if template_folder
        Dir["#{template_folder}/*.html.erb"].each { |file|
          symbol = file.split("/").last.split(".").first.to_sym
          views[symbol] = ERB.new(open(file).read)
        }
      end
      views
    end

    def get_filter_results
      # run filters in sequence
      filter_results = {}
      filter_results[:titlefilter] = AsciiDoc::Filters::TitleFilter.filter(element)
      filter_results[:tocfilter] = AsciiDoc::Filters::TOCFilter.filter(element)
      filter_results[:anchorfilter] = AsciiDoc::Filters::AnchorFilter.filter(element)
      filter_results[:indexfilter] = AsciiDoc::Filters::IndexFilter.filter(element)
      filter_results

      # run all filters
      #filters = AsciiDoc::Filters.constants
      #filters.each do |class_name|
        #filter_results[class_name.downcase.to_sym] = AsciiDoc::Filters.const_get(class_name).filter(element)
      #end
    end

    def render_to_file(result, file)
      FileUtils.mkdir_p(File.dirname(file))
      File.open(file, 'w') {|f| f.write(result) }
    end

  end

end