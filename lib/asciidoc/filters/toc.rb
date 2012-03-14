# A filter is a class that has a "filter" method that takes an array of all AsciiElements, do something with them, and return a result.
# Here we use it for generating the structure for the Table of Contents

module AsciiDoc
  module Filters
    class TOC
      def self.filter(elements)
        levels = [:title1, :title2]
        hie = []
        elements.each do |child|
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
  end
end