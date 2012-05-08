require 'asciidoc'
require 'test/unit'
require 'rack/test'
require 'fileutils'
require 'nokogiri'

ENV['RACK_ENV'] = 'test'

class AsciidocTest < Test::Unit::TestCase
  
  include Rack::Test::Methods
  
  def get_result(asc_string)
    document = AsciiDoc::AsciiDocument.new(asc_string)
    html = document.render(:html, :layout => false)
    Nokogiri::HTML(html)
  end
  
  # Asciidoc Syntax
  # -------------------------------------------------
  
  def test_link
    result = get_result("link:some/url[This is a link]")
    assert_equal(result.css("a").first.attribute("href").value, "some/url")
    assert_equal(result.css("a").first.content.strip, "This is a link")
  end
  
  def test_image
    result = get_result("image::myimage.jpg[This is an img]")
    assert_equal(result.css("img").first.attribute("src").value, "myimage.jpg")
    assert_equal(result.css("img").first.attribute("alt").value, "This is an img")
  end
  
  def test_headings
    result = get_result("= Heading1\n\nThis is some text\n\n== Heading2\n\n=== Heading3\n\n==== Heading4\n\n===== Heading5")
    assert_equal(result.css("h1").first.content, "Heading1")
    assert_equal(result.css("h2").first.content, "Heading2")
    assert_equal(result.css("h3").first.content, "Heading3")
    assert_equal(result.css("h4").first.content, "Heading4")
    assert_equal(result.css("h5").first.content, "Heading5")
  end
  
  def test_paragraph
    result = get_result("Hello my name is Rune")
    assert_equal(result.css("p").first.content, "Hello my name is Rune")
  end
  
  def test_lists
    result = get_result("- First ul\n- Second ul\n - Third ul\n1. First ol\n2. Second ol\n3. Third ol")
    assert_equal(result.css("li").size, 6)
    assert_equal(result.css("ul li").first.content.strip, "First ul")
    assert_equal(result.css("ol li").first.content.strip, "First ol")
  end
  
  def test_blockquote
    syntax = <<-EOS
[quote, Rune Madsen, Best Quotes]
____________________________________________________________________
ITP is great!
____________________________________________________________________
EOS
    
    result = get_result(syntax)
    assert result.css("blockquote").first.content =~ /ITP is great!/
    assert result.css("blockquote").first.content =~ /Rune Madsen/
  end
  
  def test_admonition_blocks
    syntax = <<-EOS
[NOTE]
.A note title
=====================================================================
This is a note
The note has two lines
=====================================================================

[TIP]
.A tip title
=====================================================================
This is a tip
The tip has two lines
=====================================================================

[IMPORTANT]
.A important title
=====================================================================
This is an important box
The important box has two lines
=====================================================================

[WARNING]
.A warning title
=====================================================================
This is a warning
The warning has two lines
=====================================================================

[CAUTION]
.A caution title
=====================================================================
This is a caution
The caution has two lines
=====================================================================
EOS
    
    result = get_result(syntax)
    puts result
    assert result.css("div.note").first.content =~ /This is a note\sThe note has two lines/
    assert_equal("A note title", result.css("div.note h1").first.content) # this is h1 because there are no heading or titles
  end
  
end