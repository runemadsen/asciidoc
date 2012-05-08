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
  
end