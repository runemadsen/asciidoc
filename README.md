Prerequisites
-------------

You will need to have wkhtmltopdf installed with the patched version of QT. The easiest way to do this on OSX is with Homebrew:
brew install WKHTMLTOPDF

For other OS: https://github.com/pdfkit/pdfkit/wiki/Installing-WKHTMLTOPDF

Plugins
-------

All of the Asciidoc tags are specified as plugins. Each plugin has a regex that if true, a lmbda will get called that parses the tag and creates an asciielement from it.

Filters
-------

Filters are functions that run after the asciidoc has been parsed, but before it outputs to HTML. This allows to create filters that count elements, creates hierachy of elements, etc. This is currently used to generate a TOC. All views have access to the filter_results variable, that holds all results of all filters.

Installation
------------

NB: This is a super early version of this gem. Use only for testing purposes

To install the gem, simply run:

    gem install 'asciidoc'

Or the bundler equivalent:

    bundle install 'asciidoc'

For usage examples see my Magic-Book-Project repo.