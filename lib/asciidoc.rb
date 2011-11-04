Dir["asciidoc/plugins/lines/*.rb"].each {|file| require file }
Dir["asciidoc/plugins/chars/*.rb"].each {|file| require file }
# does the user require the custom plugins from outside, before using the asciidoc class?

require 'asciidoc/asciielement'
require 'asciidoc/asciilines'
require 'asciidoc/asciiblock'
require 'asciidoc/asciichars'
require 'asciidoc/asciiplugins'
require 'asciidoc/asciidoc'


