class ImageSqueeze
  module Utils
    def self.image_utility_available?(bin, extension, raise_when_missing = false)
      return true if system("which #{bin} > /dev/null")
      if raise_when_missing
        ImageSqueeze.logger.error("#{bin} utility is required for running ImageSqueeze, get it installed already")
        raise StandardError, "#{bin} utility is required for running ImageSqueeze, get it installed already"
      else
        ImageSqueeze.logger.warn("#{bin} utility could not be found, your #{extension} files won't be squeezed")
      end
      false
    end
  end
end