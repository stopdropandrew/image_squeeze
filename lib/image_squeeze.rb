$:.unshift File.dirname(__FILE__)

require 'logger'
require 'image_squeeze/log_factory'
require 'image_squeeze/check_utilities'
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
  
  def self.logger
    LogFactory.logger
  end
end

ImageSqueeze::CheckUtilities.available?('identify', 'all image', Logger::ERROR)
ImageSqueeze::CheckUtilities.available?('convert', 'gif', Logger::WARN)
ImageSqueeze::CheckUtilities.available?('gifsicle', 'animated gif', Logger::WARN)
ImageSqueeze::CheckUtilities.available?('pngcrush', 'pngs and gif', Logger::WARN)
ImageSqueeze::CheckUtilities.available?('jpegtran', 'jpeg', Logger::WARN)

