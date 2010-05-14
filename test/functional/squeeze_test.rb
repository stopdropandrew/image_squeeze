require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'mocha'

class SqueezeTest < Test::Unit::TestCase
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

  def test_squeeze_results_in_unoptimized_for_unknown_file_type
    result = ImageSqueeze.squeeze(__FILE__)
    assert result.unoptimized?
  end

  def test_squeeze_results_in_unoptimized_for_file_not_found
    result = ImageSqueeze.squeeze('thisisnotarealfile.jjj')
    assert result.unoptimized?
  end
  
  def test_image_processors_squeeze_method_is_called
    ImageSqueeze.clear_image_processors
    ImageSqueeze.add_image_processor(ImageSqueeze::GIF, AlwaysOptimize)
    ImageSqueeze.add_image_processor(ImageSqueeze::GIF, NeverOptimize)

    AlwaysOptimize.any_instance.expects(:squeeze)
    NeverOptimize.any_instance.expects(:squeeze)
    ImageSqueeze.squeeze(fixtures('already_optimized_gif.gif'))
  ensure
    ImageSqueeze.reset_default_image_processors
  end
end