$:.unshift File.dirname(__FILE__)

require 'logger'
require 'image_squeeze/log_factory'
require 'image_squeeze/utils'
require 'image_squeeze/image_identifier'
require 'image_squeeze/result'

# processors
require 'image_squeeze/processors/processor'

class ImageSqueeze
  VERSION = '0.1'
  
  # Image Types
  GIF = 'gif'
  ANIMATED_GIF = 'animated gif'
  JPEG = 'jpeg'
  PNG = 'png'
  UNKNOWN = 'unknown'
  NOT_FOUND = 'not_found'
  
  def initialize(options = {})
    @image_processors = options[:image_processors] || self.class.default_image_processors
  end
  
  def squeeze(filename)
    image_type = self.class.image_type(filename)
    
    new_filename = nil
    @image_processors[image_type].each do |processor_class|
      processor = processor_class.new(filename)
      processor.squeeze
      new_filename = processor.new_filename
    end
    
    Result.new(:filename => filename, :new_filename => new_filename)
  end
  
  def logger
    LogFactory.logger
  end
  
  def self.default_image_processors
    ImageSqueeze::Utils.image_utility_available?('identify', 'all image', Logger::ERROR)
    ImageSqueeze::Utils.image_utility_available?('convert', 'gif', Logger::WARN)
    ImageSqueeze::Utils.image_utility_available?('gifsicle', 'animated gif', Logger::WARN)
    ImageSqueeze::Utils.image_utility_available?('pngcrush', 'pngs and gif', Logger::WARN)
    ImageSqueeze::Utils.image_utility_available?('jpegtran', 'jpeg', Logger::WARN)
    Hash.new([])
  end
end
