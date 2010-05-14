$:.unshift File.dirname(__FILE__)

require 'logger'
require 'image_squeeze/log_factory'
require 'image_squeeze/utils'
require 'image_squeeze/image_identifier'
require 'image_squeeze/result'

# processors
require 'image_squeeze/processors/processor'

module ImageSqueeze
  VERSION = '0.1'
  
  # Image Types
  GIF = 'gif'
  ANIMATED_GIF = 'animated gif'
  JPEG = 'jpeg'
  PNG = 'png'
  UNKNOWN = 'unknown'
  NOT_FOUND = 'not_found'
  
  def squeeze(filename)
    image_type = image_type(filename)
    
    @@image_processors[image_type].each do |processor_class|
      processor = processor_class.new(filename)
      processor.squeeze
    end
    
    Result.new
  end
  module_function :squeeze
  
  def logger
    LogFactory.logger
  end
  module_function :logger
  
  def reset_default_image_processors
    @@image_processors = Hash.new([])
    ImageSqueeze::Utils.image_utility_available?('identify', 'all image', Logger::ERROR)
    ImageSqueeze::Utils.image_utility_available?('convert', 'gif', Logger::WARN)
    ImageSqueeze::Utils.image_utility_available?('gifsicle', 'animated gif', Logger::WARN)
    ImageSqueeze::Utils.image_utility_available?('pngcrush', 'pngs and gif', Logger::WARN)
    ImageSqueeze::Utils.image_utility_available?('jpegtran', 'jpeg', Logger::WARN)
  end
  module_function :reset_default_image_processors
  
  def clear_image_processors
    @@image_processors = Hash.new([])
  end
  module_function :clear_image_processors
  
  def add_image_processor(image_type, processor_class)
    @@image_processors[image_type] ||= []
    @@image_processors[image_type] << processor_class
  end
  module_function :add_image_processor
end

ImageSqueeze.reset_default_image_processors