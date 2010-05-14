require File.join(File.dirname(__FILE__), '..', 'test_helper')

class DefaultProcessorsTest < Test::Unit::TestCase
  def test_png_crush_processor_with_unoptimize_png
    assert_processor_optimizes_file(ImageSqueeze::PNGCrushProcessor, 'unoptimized_png.png')
  end
  
  def test_png_crush_processor_with_optimized_png
    assert_processor_doesnt_optimize_file(ImageSqueeze::PNGCrushProcessor, 'already_optimized_png.png')
  end
  
  def test_jpegtran_progressive_processor_with_already_optimized
    assert_processor_doesnt_optimize_file(ImageSqueeze::JPEGTranProgressiveProcessor, 'already_optimized_jpg.jpg')
  end

  def test_jpegtran_progressive_processor_with_progressive_optimized
    assert_processor_optimizes_file(ImageSqueeze::JPEGTranProgressiveProcessor, 'better_as_progressive.jpg')
  end

  def test_jpegtran_non_progressive_processor_with_already_optimized
    assert_processor_doesnt_optimize_file(ImageSqueeze::JPEGTranNonProgressiveProcessor, 'already_optimized_jpg.jpg')
  end

  def test_jpegtran_non_progressive_processor_with_progressive_optimized
    assert_processor_optimizes_file(ImageSqueeze::JPEGTranNonProgressiveProcessor, 'better_without_progressive.jpg')
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