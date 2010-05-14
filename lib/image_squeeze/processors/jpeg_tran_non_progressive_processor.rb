class ImageSqueeze
  class JPEGTranNonProgressiveProcessor < Processor
    def self.input_type
      JPEG
    end
    
    def self.squeeze(filename, output_filename)
      system("jpegtran -copy none -optimize #{filename} > #{output_filename}")
    end
  end
end