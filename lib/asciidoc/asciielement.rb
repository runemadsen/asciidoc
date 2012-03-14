module AsciiDoc
  
  class AsciiElement

    attr_accessor :children, :type, :attributes
    
    def initialize(type)
      @attributes = {}
      @type = type
      @children = []
    end

    def render(views, filter_results)
      element = self
      raise Exception, "Template file doesn't exist: #{@type}" if views[@type].nil?
      views[@type].result(binding)
    end

    def render_children(views, filter_results)
      content = ""
      @children.each do |child|
        if(child.is_a? String)
          content += child
        else
          content += child.render(views, filter_results)
        end
      end
      content
    end
    
  end
  
end