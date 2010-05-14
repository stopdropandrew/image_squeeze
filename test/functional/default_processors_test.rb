require File.join(File.dirname(__FILE__), '..', 'test_helper')

class DefaultProcessorsTest < Test::Unit::TestCase
  def test_png_crush_processor_with_unoptimize_png
    assert_processor_optimizes_file(ImageSqueeze::PNGCrushProcessor, 'unoptimized_png.png')
  end

  def test_png_crush_processor_with_optimized_png
    assert_processor_doesnt_optimize_file(ImageSqueeze::PNGCrushProcessor, 'already_optimized_png.png')
  end
  
  private
  def assert_processor_optimizes_file(processor, file)
    squeezer = ImageSqueeze.new(:processors => [processor])
    filename = fixtures(file)
    old_size = File.size(filename)
    squeezer.squeeze!(filename)
    assert File.size(filename) < old_size
  end
  
  def assert_processor_doesnt_optimize_file(processor, file)
    squeezer = ImageSqueeze.new(:processors => [processor])
    filename = fixtures(file)
    old_size = File.size(filename)
    squeezer.squeeze!(filename)
    assert File.size(filename) == old_size
  end
end