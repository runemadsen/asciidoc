require 'asciidoc/ascii_element'

# require all filters
Dir[File.dirname(__FILE__) + '/asciidoc/filters/*.rb'].each {|file| require file }

# require all elements
Dir[File.dirname(__FILE__) + '/asciidoc/elements/*.rb'].each {|file| require file }

require 'asciidoc/ascii_document'
