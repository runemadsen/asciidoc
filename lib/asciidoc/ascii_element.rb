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
    
    # This function is a reference map that tells the system to load a specific view for a specific XML node. 
    # All node names that are not stated here will automatically load a view name corresponding to their name
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
    
    # This function is a reference map that tells the system to load a specific model based on the xml node name.
    # All node names that are not stated here will automatically try to find a model with their name, or pass through bare text if not found
    def xml_to_model_name(xml_name)
      convert = {
        "itemizedlist" => "list",
        "orderedlist" => "list",
        "inlinemediaobject" => "media",
        "mediaobject" => "media",
        "programlisting" => "source",
        "articleinfo" => "info",
        "ulink" => "link",
        "note" => "admonition",
        "tip" => "admonition",
        "important" => "admonition",
        "warning" => "admonition",
        "caution" => "admonition"
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
    
    # this is used by views to avoid crazy syntax when outputting attributes
    def att(name, new_name = nil)
      attr_name = new_name || name
      if @attributes[name]
        return "#{attr_name}=\"#{@attributes[name]}\""
      else
        return ""
      end
    end
      
  end
  
end