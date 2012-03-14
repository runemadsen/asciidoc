class TOCHelper
  
  def self.get_hierachy(children, level = 2)
    levels = [:title1, :title2]
    hie = []
    children.each do |child|
      if child.is_a?(AsciiDoc::AsciiElement)
        if child.type == levels[0]
          hie << { :el => child, :children => [] }
        elsif child.type == levels[1]
          hie.last[:children] << { :el => child, :children => [] }
        end
      end
    end
    hie
  end
  
end