$:.unshift File.dirname(__FILE__)

require 'logger'
require 'image_squeeze/log_factory'
require 'image_squeeze/utils'
require 'image_squeeze/image_identifier'

module ImageSqueeze
  VERSION = '0.1'
  
  # Image Types
  GIF = 'gif'
  ANIMATED_GIF = 'animated gif'
  JPEG = 'jpeg'
  PNG = 'png'
  UNKNOWN = 'unknown'
  NOT_FOUND = 'not_found'
  
  def logger
    LogFactory.logger
  end
  module_function :logger
end

ImageSqueeze::Utils.image_utility_available?('identify', 'all image', Logger::ERROR)
ImageSqueeze::Utils.image_utility_available?('convert', 'gif', Logger::WARN)
ImageSqueeze::Utils.image_utility_available?('gifsicle', 'animated gif', Logger::WARN)
ImageSqueeze::Utils.image_utility_available?('pngcrush', 'pngs and gif', Logger::WARN)
ImageSqueeze::Utils.image_utility_available?('jpegtran', 'jpeg', Logger::WARN)

