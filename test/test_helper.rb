require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'image_squeeze')
require 'ruby-debug'
Debugger.start

class Test::Unit::TestCase
  def fixtures(filename)
    File.join(File.dirname(__FILE__), 'fixtures', filename)
  end
end