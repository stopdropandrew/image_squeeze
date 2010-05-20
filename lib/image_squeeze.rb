$:.unshift File.dirname(__FILE__)

require 'tempfile'
require 'logger'

require 'image_squeeze/log_factory'
require 'image_squeeze/utils'
require 'image_squeeze/image_identifier'
require 'image_squeeze/result'

# processors
require 'image_squeeze/processors/processor'
require 'image_squeeze/processors/png_crush_processor'
require 'image_squeeze/processors/jpeg_tran_progressive_processor'
require 'image_squeeze/processors/jpeg_tran_non_progressive_processor'
require 'image_squeeze/processors/gifsicle_processor'
require 'image_squeeze/processors/gif_to_png_processor'

class ImageSqueeze
  attr_reader :processors
  attr_reader :tmpdir
  
  VERSION = '0.1.1'
  
  # Image Types
  GIF = 'gif'
  ANIMATED_GIF = 'animated gif'
  JPEG = 'jpeg'
  PNG = 'png'
  UNKNOWN = 'unknown'
  NOT_FOUND = 'not_found'
  
  IMAGE_TYPE_TO_EXTENSION = {
    GIF => '.gif',
    ANIMATED_GIF => '.gif',
    JPEG => '.jpg',
    PNG => '.png'
  }
  
  def initialize(options = {})
    # identify is required
    ImageSqueeze::Utils.image_utility_available?('identify', 'all image', Logger::ERROR)
    
    @processors = options[:processors] || []
    @processors += self.class.default_processors if options[:default_processors]
    
    @tmpdir = options[:tmpdir] || Dir::tmpdir
  end
  
  def self.default
    @processors = self.class.default_processors
  end
  
  def squeeze(filename)
    image_type = self.class.image_type(filename)
    return if [UNKNOWN, NOT_FOUND].include?(image_type)

    processors = @processors.select{ |processor| processor.handles?(image_type) }
    return if processors.empty?
    
    original_file_size = File.size(filename)
    sorted_results = processors.map do |processor_class|
      output_filename = tmp_filename(filename)
      processor_class.squeeze(filename, output_filename)
      output_file_size = File.size(output_filename)
      result_options = { :filename => filename, :output_filename => output_filename, :bytes_saved => original_file_size - output_file_size, :output_extension => processor_class.output_extension }
      Result.new(result_options)
    end.sort
    
    most_optimized = sorted_results.pop if sorted_results[-1].optimized?
    sorted_results.each do |result|
      FileUtils.rm(result.output_filename)
    end
    most_optimized
  end
  
  def squeeze!(filename)
    result = squeeze(filename)
    
    output_filename = filename
    output_filename = finalize_result(result) if result
  end
  
  def finalize_result(result)
    filename = output_filename = result.filename
    if File.extname(result.filename) != result.output_extension
      output_filename = filename.sub(Regexp.new(Regexp.escape(File.extname(result.filename)) + '$'), result.output_extension)
      FileUtils.mv(result.output_filename, output_filename)
      FileUtils.rm(result.filename)
    else
      FileUtils.mv(result.output_filename, result.filename)
    end
    output_filename
  end
  
  def self.logger
    LogFactory.logger
  end
  
  def logger
    self.class.logger
  end
  
  def self.default_processors
    processors = []
    ImageSqueeze::Utils.image_utility_available?('identify', 'all image', true)
    if ImageSqueeze::Utils.image_utility_available?('pngcrush', 'pngs and gif')
      processors << PNGCrushProcessor
      processors << GIFToPNGProcessor if ImageSqueeze::Utils.image_utility_available?('convert', 'gif')
    end
    processors << GifsicleProcessor if ImageSqueeze::Utils.image_utility_available?('gifsicle', 'animated gif')
    if ImageSqueeze::Utils.image_utility_available?('jpegtran', 'jpeg')
      processors << JPEGTranProgressiveProcessor
      processors << JPEGTranNonProgressiveProcessor
    end
    processors
  end
  
  private
  def tmp_filename(filename)
    t = Time.now.strftime("%Y%m%d")
    path = "#{File.basename(filename)}#{t}-#{$$}-#{rand(0x100000000).to_s(36)}"
       
    File.join(tmpdir, path)
  end
  
end
