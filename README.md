Installation
------------

NB: This is a super early version of this gem. Use only for testing purposes

To install the gem, simply run:

    gem install 'asciidoc'

Or the bundler equivalent:

    bundle install 'asciidoc'

Usage Examples
--------------

Warning: You need to create a html template in order to output to HTML / PDF. Examples on this can be found in my "magicbookproject" github repo.

    # create a html file from your asciidoc file
    @document = AsciiDoc::AsciiDocument.new(open("your.asciidoc").read)
    @document.render(:html, "template/folder", "output/folder")

    # create a pdf file from your asciidoc file
    @document = AsciiDoc::AsciiDocument.new(open("your.asciidoc").read)
    @document.render(:pdf, "template/folder", "output/folder")