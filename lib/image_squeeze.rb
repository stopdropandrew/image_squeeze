$:.unshift File.dirname(__FILE__)

require 'image_squeeze/log_factory'

module ImageSqueeze
  VERSION = '0.1'
  
  def self.logger
    LogFactory.logger
  end
end