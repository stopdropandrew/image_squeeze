module ImageSqueeze
  class LogFactory
    def self.logger
      @logger ||= create_logger
    end
    
    private
    def self.create_logger
      return Rails.logger if defined?(Rails) && defined?(Rails.logger)
      return RAILS_DEFAULT_LOGGER if defined?(RAILS_DEFAULT_LOGGER)
      return Logger.new(STDERR)
    end
  end
end