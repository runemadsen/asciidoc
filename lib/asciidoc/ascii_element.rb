module AsciiDoc
  
  class AsciiElement

    attr_accessor :children, :type, :attributes
    
    def initialize(xml)
      @children = []
      parse_metadata(xml)
      parse(xml)
    end

    def parse_metadata(xml)
      @type = xml.name.to_sym
      @attributes = xml.attributes
    end
    
    def parse(xml)   
      xml.children.each do |node|
        if class_exists?(node.name)
          @children << to_class(node.name).new(node)
        elsif node.text?
          # this takes for granted that textnodes never have attributes, as we throw all that away
          @children << node.content unless node.content == "\n"
        else
          @children << AsciiDoc::AsciiElement.new(node)
        end
      end
    end
    
    def render(views, filter_results)      
      # if there's a template view, use it
      if views[xml_to_view_name(@type)]
        views[xml_to_view_name(@type)].result(binding)      
      
      # TODO: other wise if there is a default view, use it
      
      # else if there is no view at all, just render the children as bare string
      # this is all the elements that we don't want tags for
      else
        render_children(views, filter_results)
      end
    end

    def render_children(views, filter_results)
      @children.map { |child|
        if child.is_a? String
          child
        else
          child.render(views, filter_results)
        end
      }.join
    end
    
    # All these functions should be moved to global place / module or something
    # -------------------------------------------------------
    
    def xml_to_view_name(xml_name)
      convert = {
        :article => :document,
        :simpara => :paragraph
      }
      convert[xml_name] || xml_name
    end
    
    def class_exists?(class_name)
      AsciiDoc.const_defined?(class_name.capitalize + "Element")
    end
    
    def to_class(class_name)
      AsciiDoc.const_get(class_name.capitalize + "Element")
    end
    
    def node_content(xml, node_name)
      node = xml.at_xpath("//#{node_name}")
      node ? node.content : nil
    end
      
  end
  
end