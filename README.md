Prerequisites
-------------

You will need to have wkhtmltopdf installed with the patched version of QT. The easiest way to do this on OSX is with Homebrew:
brew install WKHTMLTOPDF

For other OS: https://github.com/pdfkit/pdfkit/wiki/Installing-WKHTMLTOPDF

Installation
------------

NB: This is a super early version of this gem. Use only for testing purposes

To install the gem, simply run:

    gem install 'asciidoc'

Or the bundler equivalent:

    bundle install 'asciidoc'

Usage Examples
--------------

You need to create a html template in order to output to HTML / PDF. Examples on this can be found in my "magicbookproject" github repo.

    # create a html file from your asciidoc file
    @document = AsciiDoc::AsciiDocument.new("your.asciidoc")
    @document.render(:html, "template/folder", "output/folder")

    # create a pdf file from your asciidoc file
    @document = AsciiDoc::AsciiDocument.new("your.asciidoc")
    @document.render(:pdf, "template/folder", "output/folder")