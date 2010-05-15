$:.unshift File.dirname(__FILE__)

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

class ImageSqueeze
  VERSION = '0.1'
  
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
    @processors = options[:processors] || []
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
      output_filename = processor_class.squeeze_to_tmp(filename)
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
    if result
      if File.extname(filename) != result.output_extension
        output_filename = filename.sub(Regexp.new(Regexp.escape(File.extname(filename)) + '$'), result.output_extension)
        FileUtils.cp(result.output_filename, output_filename)
        FileUtils.rm(filename)
      else
        FileUtils.cp(result.output_filename, filename)
      end
    end
    output_filename
  end
  
  def logger
    LogFactory.logger
  end
  
  def self.default_processors
    ImageSqueeze::Utils.image_utility_available?('identify', 'all image', Logger::ERROR)
    ImageSqueeze::Utils.image_utility_available?('convert', 'gif', Logger::WARN)
    ImageSqueeze::Utils.image_utility_available?('gifsicle', 'animated gif', Logger::WARN)
    ImageSqueeze::Utils.image_utility_available?('pngcrush', 'pngs and gif', Logger::WARN)
    ImageSqueeze::Utils.image_utility_available?('jpegtran', 'jpeg', Logger::WARN)
    Hash.new([])
  end
end
