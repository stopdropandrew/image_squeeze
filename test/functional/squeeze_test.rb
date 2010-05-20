require File.join(File.dirname(__FILE__), '..', 'test_helper')

class SqueezeTest < Test::Unit::TestCase
  def setup
    @image_squeezer = ImageSqueeze.new
  end
  
  def test_squeeze_results_in_unoptimized_for_unknown_file_type
    assert !@image_squeezer.squeeze(__FILE__)
  end

  def test_squeeze_result_is_unoptimized_for_file_not_found
    assert !@image_squeezer.squeeze('thisisnotarealfile.jjj')
  end
  
  def test_squeeze_a_image_without_a_processor
    assert !@image_squeezer.squeeze(fixtures('already_optimized_gif.gif'))
  end

  def test_squeeze_result_is_unoptimized_when_no_optimization_is_made
    image_squeezer = custom_image_squeezer(NeverOptimize)
    assert !image_squeezer.squeeze(fixtures('already_optimized_gif.gif'))
  end

  def test_squeeze_result_is_deleted_when_no_optimization_is_made
    image_squeezer = custom_image_squeezer(NeverOptimize)
    NeverOptimize.stubs(:tmp_filename).returns(output_filename = File.join(File.dirname(__FILE__), '..', 'tmp', 'tmpfile'))
    assert !image_squeezer.squeeze(fixtures('already_optimized_gif.gif'))
    assert !File.exists?(output_filename)
  end

  def test_squeeze_result_is_optimized_when_an_optimization_is_made
    image_squeezer = custom_image_squeezer(AlwaysOptimize)
    result = image_squeezer.squeeze(fixtures('already_optimized_gif.gif'))
    assert result.optimized?
  end
  
  def test_squeeze_picks_the_best_result_when_processors_return_different_sizes
    image_squeezer = custom_image_squeezer(AlwaysOptimize, NeverOptimize)
    result = image_squeezer.squeeze(fixtures('already_optimized_gif.gif'))
    assert result.optimized?
  end
  
  def test_squeezebang_overwrites_original_file
    image_squeezer = custom_image_squeezer(AlwaysOptimize)
    filename = fixtures('already_optimized_gif.gif')
    old_size = File.size(filename)
    result = image_squeezer.squeeze!(filename)
    
    assert File.size(filename) < old_size
  end

  def test_squeezebang_removes_old_file_when_extension_is_changed
    image_squeezer = custom_image_squeezer(PNGOutput)
    filename = fixtures('already_optimized_gif.gif')
    result = image_squeezer.squeeze!(filename)
    
    assert !File.exists?(filename), "Old file should be gone"
    assert File.exists?(filename.gsub(/\.gif/, '.png')), "New file should exist"
  end

  def test_squeezebang_handles_changing_extension_when_dot_extension_is_repeated
    image_squeezer = custom_image_squeezer(PNGOutput)
    filename = fixtures('gif.gif.gif.gif')
    result = image_squeezer.squeeze!(filename)
    
    assert !File.exists?(filename), "Old file should be gone"
    assert File.exists?(filename.gsub(/\.gif$/, '.png')), "New file should exist"
  end
  
  def test_squeezebang_doesnt_overwrite_when_file_not_optimized
    image_squeezer = custom_image_squeezer(AlwaysBigger)
    filename = fixtures('already_optimized_gif.gif')
    old_size = File.size(filename)
    result = image_squeezer.squeeze!(filename)
    assert_equal old_size, File.size(filename)
  end
  
  def test_override_tmp_dir_stores_output_files_in_correct_location
    tmpdir = File.join(File.dirname(__FILE__), '..', 'tmp')
    FileUtils.mkdir_p(tmpdir)
    image_squeezer = custom_image_squeezer(AlwaysOptimize, :tmpdir => tmpdir)
    
    result = image_squeezer.squeeze(fixtures('already_optimized_gif.gif'))
    assert_equal 0, result.output_filename.index(tmpdir), "Output file should be located in tmpdir: #{tmpdir}"
  ensure
    FileUtils.rm(result.output_filename) if result && result.output_filename && File.exists?(result.output_filename)
  end
  
  def test_finalize_result_should_remove_old_file_when_extension_doesnt_change
    image_squeezer = custom_image_squeezer(AlwaysOptimize)
    filename = fixtures('already_optimized_gif.gif')
    result = image_squeezer.squeeze(filename)

    assert File.exists?(result.output_filename)
    image_squeezer.finalize_result(result)
    assert !File.exists?(result.output_filename)
  end

  def test_finalize_result_should_remove_old_file_when_extension_changes
    image_squeezer = custom_image_squeezer(PNGOutput)
    filename = fixtures('already_optimized_gif.gif')
    result = image_squeezer.squeeze(filename)

    assert File.exists?(result.output_filename)
    image_squeezer.finalize_result(result)
    assert !File.exists?(result.output_filename)
  end
  
  private
  class AlwaysOptimize < ImageSqueeze::Processor
    def self.squeeze(filename, output_filename)
      `echo 'real small' > #{output_filename}` # this will make the new file really small
    end
    
    def self.input_type; ImageSqueeze::GIF; end
  end
  
  class NeverOptimize < ImageSqueeze::Processor
    def self.squeeze(filename, output_filename)
      `cp #{filename} #{output_filename}`
    end

    def self.input_type; ImageSqueeze::GIF; end
  end

  class AlwaysBigger < ImageSqueeze::Processor
    def self.squeeze(filename, output_filename)
      `cp #{filename} #{output_filename}; echo "hi" >> #{output_filename}`
    end
    def self.input_type; ImageSqueeze::GIF; end
  end

  class PNGOutput < ImageSqueeze::Processor
    def self.squeeze(filename, output_filename)
      `echo 'real small' > #{output_filename}` # this will make the new file really small
    end
    
    def self.input_type; ImageSqueeze::GIF; end
    def self.output_extension; '.png'; end
  end

  def custom_image_squeezer(*processors)
    options = processors.last.is_a?(Hash) ? processors.pop : {}
    
    ImageSqueeze.new(options.merge(:processors => processors))
  end
end