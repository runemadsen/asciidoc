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
      @children = xml.children.map do |node|
        # TODO: if there is a class with this node name, then create that, else create a normal AsciiElement
        if node.text?
          # this takes for granted that textnodes never have attributes, as we throw all that away
          node.content
        else
          AsciiDoc::AsciiElement.new(node)
        end
      end
    end
    
    def render(views, filter_results)
      element = self
      
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
    
    # this should be moved to a global place and made smarter
    def xml_to_view_name(xml_name)
      convert = {
        :article => :document
      }
      convert[xml_name] || xml_name
    end
    
  end
  
end