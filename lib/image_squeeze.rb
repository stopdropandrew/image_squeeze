$:.unshift File.dirname(__FILE__)

require 'logger'
require 'image_squeeze/log_factory'
require 'image_squeeze/check_utilities'

module ImageSqueeze
  VERSION = '0.1'
  
  def self.logger
    LogFactory.logger
  end
end

ImageSqueeze::CheckUtilities.available?('identify', 'all image', Logger::ERROR)
ImageSqueeze::CheckUtilities.available?('convert', 'gif', Logger::WARN)
ImageSqueeze::CheckUtilities.available?('gifsicle', 'animated gif', Logger::WARN)
ImageSqueeze::CheckUtilities.available?('pngcrush', 'pngs and gif', Logger::WARN)
ImageSqueeze::CheckUtilities.available?('jpegtran', 'jpeg', Logger::WARN)

