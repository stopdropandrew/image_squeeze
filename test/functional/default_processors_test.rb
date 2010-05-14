require File.join(File.dirname(__FILE__), '..', 'test_helper')

class DefaultProcessorsTest < Test::Unit::TestCase
  def test_png_processor_with_unoptimize_png
    squeezer = ImageSqueeze.new(:image_processors => [ImageSqueeze::PNGCrushProcessor])
    filename = fixtures('unoptimized_png.png')
    old_size = File.size(filename)
    squeezer.squeeze!(filename)
    assert File.size(filename) < old_size
  end

  def test_png_processor_with_optimized_png
    squeezer = ImageSqueeze.new(:image_processors => [ImageSqueeze::PNGCrushProcessor])
    filename = fixtures('already_optimized_png.png')
    old_size = File.size(filename)
    squeezer.squeeze!(filename)
    assert File.size(filename) == old_size
  end
end