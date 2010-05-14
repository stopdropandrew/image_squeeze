require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ResultTest < Test::Unit::TestCase
  def test_results_sort_by_bytes_saved
    small = ImageSqueeze::Result.new(:bytes_saved => -10)
    medium = ImageSqueeze::Result.new(:bytes_saved => 20)
    big = ImageSqueeze::Result.new(:bytes_saved => 100)
    
    assert_equal [small, medium, big], [medium, big, small].sort
  end
end