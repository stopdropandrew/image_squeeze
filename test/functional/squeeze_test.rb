require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'mocha'

class SqueezeTest < Test::Unit::TestCase
  def setup
    @image_squeezer = ImageSqueeze.new
  end
  
  def test_squeeze_results_in_unoptimized_for_unknown_file_type
    result = @image_squeezer.squeeze(__FILE__)
    assert !result.optimized?
  end

  def test_squeeze_results_in_unoptimized_for_file_not_found
    result = @image_squeezer.squeeze('thisisnotarealfile.jjj')
    assert !result.optimized?
  end
  
  def test_image_processors_squeeze_method_is_called
    image_squeezer = custom_image_squeezer(AlwaysOptimize, NeverOptimize)
    AlwaysOptimize.expects(:squeeze)
    NeverOptimize.expects(:squeeze)
    image_squeezer.squeeze(fixtures('already_optimized_gif.gif'))
  end

  def test_squeeze_result_in_unoptimized_when_no_optimization_is_made
    image_squeezer = custom_image_squeezer(NeverOptimize)
    result = image_squeezer.squeeze(fixtures('already_optimized_gif.gif'))
    assert !result.optimized?
  end

  def test_squeeze_result_in_optimized_when_an_optimization_is_made
    image_squeezer = custom_image_squeezer(AlwaysOptimize)
    result = image_squeezer.squeeze(fixtures('already_optimized_gif.gif'))
    assert result.optimized?
  end
  
  private
  class AlwaysOptimize < ImageSqueeze::Processor
    def self.squeeze(filename, output_filename)
      `echo 'real small' > #{output_filename}` # this will make the new file really small
    end
  end
  
  class NeverOptimize < ImageSqueeze::Processor
    def self.squeeze(filename, output_filename)
      `cp #{filename} #{output_filename}`
    end
  end

  def custom_image_squeezer(*processors)
    ImageSqueeze.new(:image_processors => { ImageSqueeze::GIF => processors } )
  end
end