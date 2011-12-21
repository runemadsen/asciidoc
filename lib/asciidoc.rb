require 'asciidoc/attributeshelper'

require 'asciidoc/asciiplugins'
require 'asciidoc/asciicharplugins'

require 'asciidoc/asciielement'
require 'asciidoc/asciilines'
require 'asciidoc/asciiblock'
require 'asciidoc/asciichars'

Dir[File.dirname(__FILE__) + '/asciidoc/plugins/lines/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/asciidoc/plugins/chars/*.rb'].each {|file| require file }

require 'asciidoc/asciidocument'
