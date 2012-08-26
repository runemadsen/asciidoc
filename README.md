About
-----

This gem makes it possible to publish books in PDF and HTML format using only Asciidoc, HTML (Ruby .erb views) and CSS.  It's built on the premise that you want to write books like you write a modern web application: You have your data (Asciidoc text) that you present in custom views (.erb files) that you can style with CSS. No need for crazy XSLT stylesheets.

The gem was developed for Daniel Shiffman's "The Nature of Code" book, released via Kickstarter funding. There is still some way to go, but we're working on hard on releasing a stable version 1.0. 


Dependencies
------------

This gem uses the asciidoc program to parse text into XML.
It also uses Prince XML for PDF rendering (we are using this until we find a good, open-source HTML to PDF renderer)
