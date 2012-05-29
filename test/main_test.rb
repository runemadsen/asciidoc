require 'asciidoc'
require 'test/unit'
require 'rack/test'
require 'fileutils'
require 'nokogiri'

ENV['RACK_ENV'] = 'test'

class AsciidocTest < Test::Unit::TestCase
  
  include Rack::Test::Methods
  
  def get_result(asc_string, args = {})
    document = AsciiDoc::AsciiDocument.new(asc_string)
    puts document.xml if args[:debug_xml]
    html = document.render(:html, :layout => false)
    puts html if args[:debug_html]
    Nokogiri::HTML(html)
  end
  
  # Asciidoc Syntax
  # -------------------------------------------------
  
  def test_link
    result = get_result("link:some/url[This is a link]")
    assert_equal("some/url", result.css("a").first.attribute("href").value)
    assert_equal("This is a link", result.css("a").first.content.strip)
  end
  
  def test_image
    result = get_result("image::myimage.jpg[This is an img]")
    assert_equal("myimage.jpg", result.css("img").first.attribute("src").value)
    assert_equal("This is an img", result.css("img").first.attribute("alt").value)
  end
  
  def test_headings
    result = get_result("= Heading1\n\nThis is some text\n\n== Heading2\n\n=== Heading3\n\n==== Heading4\n\n===== Heading5")
    assert_equal("Heading1", result.css("h1").first.content)
    assert_equal("Heading2", result.css("h2").first.content)
    assert_equal("Heading3", result.css("h3").first.content)
    assert_equal("Heading4", result.css("h4").first.content)
    assert_equal("Heading5", result.css("h5").first.content)
  end
  
  def test_paragraph
    result = get_result("Hello my name is Rune")
    assert_equal("Hello my name is Rune", result.css("p").first.content)
  end
  
  def test_lists
    result = get_result("- First ul\n- Second ul\n - Third ul\n1. First ol\n2. Second ol\n3. Third ol")
    assert_equal(result.css("li").size, 6)
    assert_equal("First ul", result.css("ul li").first.content.strip)
    assert_equal("First ol", result.css("ol li").first.content.strip)
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
    assert result.css("div.note").first.content =~ /This is a note\sThe note has two lines/
    assert_equal("A note title", result.css("div.note h1").first.content) # this is h1 because there are no heading or titles
  end
  
  def test_styles
    result = get_result("Rune is a very *bold* _italic_ man")
    assert_equal("bold", result.css("strong").first.content)
    assert_equal("italic", result.css("em").first.content)
  end
  
  def test_custom_span
    result = get_result("Rune has a [line-through]*line through* himself and a [custom]*custom class*")
    assert_equal("line through", result.css("span.line-through").first.content)
    assert_equal("custom class", result.css("span.custom").first.content)
  end
  
  def test_super_sub_script
    result = get_result("n^1^ and n~2~")
    assert_equal("1", result.css("sup").first.content)
    assert_equal("2", result.css("sub").first.content)
  end
  
end