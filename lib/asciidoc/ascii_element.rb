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
        if class_exists?(xml_to_model_name(node.name))
          @children << to_class(xml_to_model_name(node.name)).new(node)
        else
          @children << AsciiDoc::AsciiElement.new(node)
        end
      end
    end
    
    def render(views, filter_results)      
      if views[xml_to_view_name(@type)]
        views[xml_to_view_name(@type)].result(binding)      
      else
        render_children(views, filter_results)
      end
    end

    def render_children(views, filter_results)
      @children.map { |child|
          child.render(views, filter_results)
      }.join
    end
    
    # All these functions should be moved to global place / module or something
    # -------------------------------------------------------
    
    def xml_to_view_name(xml_name)
      convert = {
        :article => :document,
        :simpara => :paragraph,
        :itemizedlist => :ul,
        :orderedlist => :ol,
        :imageobject => :img
      }
      convert[xml_name] || xml_name
    end
    
    def xml_to_model_name(xml_name)
      convert = {
        "itemizedlist" => "list",
        "orderedlist" => "list",
        "inlinemediaobject" => "media",
        "mediaobject" => "media",
        "programlisting" => "source",
        "articleinfo" => "info",
        "ulink" => "link"
        
      }
      convert[xml_name] || xml_name
    end
    
    def class_exists?(class_name)
      begin
        AsciiDoc.const_defined?(class_name.capitalize + "Element")
      rescue 
        false
      end
    end
    
    def to_class(class_name)
      AsciiDoc.const_get(class_name.capitalize + "Element")
    end
    
    def node_content(xml, node_name)
      node = xml.at_xpath(".//#{node_name}")
      node ? node.content : nil
    end
      
  end
  
end