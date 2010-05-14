require 'test/unit'
require 'ruby-debug'
require File.join(File.dirname(__FILE__), '..', 'lib', 'image_squeeze')

class Test::Unit::TestCase
  def fixtures(filename)
    File.join(File.dirname(__FILE__), 'fixtures', filename)
  end
end