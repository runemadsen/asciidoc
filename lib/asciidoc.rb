require 'asciidoc/attributeshelper'

require 'asciidoc/asciiplugins'
require 'asciidoc/asciicharplugins'

require 'asciidoc/asciicounter'
require 'asciidoc/asciielement'
require 'asciidoc/asciilines'
require 'asciidoc/asciiblock'
require 'asciidoc/asciichars'

require 'asciidoc/tochelper'

# require plugins in order of execution
require 'asciidoc/plugins/lines/heading'
require 'asciidoc/plugins/lines/table'
require 'asciidoc/plugins/lines/quote'
require 'asciidoc/plugins/lines/source'
require 'asciidoc/plugins/lines/anchor'
require 'asciidoc/plugins/lines/anchor_target'
require 'asciidoc/plugins/lines/bulleted_list'
require 'asciidoc/plugins/lines/ordered_list'
require 'asciidoc/plugins/lines/example_block'
require 'asciidoc/plugins/lines/title0'
require 'asciidoc/plugins/lines/title1'
require 'asciidoc/plugins/lines/title2'
require 'asciidoc/plugins/lines/title3'
require 'asciidoc/plugins/lines/title4'
require 'asciidoc/plugins/lines/macro'
require 'asciidoc/plugins/lines/paragraph'

require 'asciidoc/plugins/chars/bold'
require 'asciidoc/plugins/chars/italic'

# don't just require them
#Dir[File.dirname(__FILE__) + '/asciidoc/plugins/lines/*.rb'].each {|file| require file }
#Dir[File.dirname(__FILE__) + '/asciidoc/plugins/chars/*.rb'].each {|file| require file }

require 'asciidoc/asciidocument'
