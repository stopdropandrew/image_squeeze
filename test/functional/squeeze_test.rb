require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'mocha'

class SqueezeTest < Test::Unit::TestCase
  def test_squeeze_results_in_unoptimized_for_unknown_file_type
    result = ImageSqueeze.squeeze(__FILE__)
    assert !result.optimized?
  end

  def test_squeeze_results_in_unoptimized_for_file_not_found
    result = ImageSqueeze.squeeze('thisisnotarealfile.jjj')
    assert !result.optimized?
  end
  
  def test_image_processors_squeeze_method_is_called
    with_custom_image_processors do
      AlwaysOptimize.any_instance.expects(:squeeze)
      NeverOptimize.any_instance.expects(:squeeze)
      ImageSqueeze.squeeze(fixtures('already_optimized_gif.gif'))
    end
  end

  def test_image_processors_squeeze_method_is_called
    with_custom_image_processors do
      AlwaysOptimize.any_instance.expects(:squeeze)
      NeverOptimize.any_instance.expects(:squeeze)
      ImageSqueeze.squeeze(fixtures('already_optimized_gif.gif'))
    end
  end

  def test_squeeze_result_in_unoptimized_when_no_optimization_is_made
    with_custom_image_processors(NeverOptimize) do
      result = ImageSqueeze.squeeze(fixtures('already_optimized_gif.gif'))
      assert !result.optimized?
    end
  end

  def test_squeeze_result_in_optimized_when_an_optimization_is_made
    with_custom_image_processors(AlwaysOptimize) do
      result = ImageSqueeze.squeeze(fixtures('already_optimized_gif.gif'))
      assert result.optimized?
    end
  end
  
  private
  class AlwaysOptimize < ImageSqueeze::Processor
    def squeeze
      `echo 'real small' > #{new_filename}` # this will make the new file really small
    end
  end
  
  class NeverOptimize < ImageSqueeze::Processor
    def squeeze
      `cp #{filename} #{new_filename}`
    end
  end

  def with_custom_image_processors(processors = [AlwaysOptimize, NeverOptimize], &block)
    ImageSqueeze.clear_image_processors
    Array(processors).each do |processor|
      ImageSqueeze.add_image_processor(ImageSqueeze::GIF, processor)
    end
    
    yield
  ensure
    ImageSqueeze.reset_default_image_processors
  end
end