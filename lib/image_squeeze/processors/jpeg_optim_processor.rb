class ImageSqueeze
  class JpegOptimProcessor < Processor
    def self.input_type
      JPEG
    end

    def self.squeeze(filename, output_filename)
      system("jpegoptim --strip-all --dest=#{output_filename} #{filename} > /dev/null")
    end
  end
end