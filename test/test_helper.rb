require 'test/unit'
require 'ruby-debug'
require File.join(File.dirname(__FILE__), '..', 'lib', 'image_squeeze')

class Test::Unit::TestCase
  def fixtures(filename)
    original_file = File.join(File.dirname(__FILE__), 'fixtures', filename)
    new_file = File.join(Dir::tmpdir, filename)
    FileUtils.cp(original_file, new_file)
    new_file
  end
end