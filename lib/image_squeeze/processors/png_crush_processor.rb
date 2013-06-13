class ImageSqueeze
  class PNGCrushProcessor < Processor
    def self.input_type
      PNG
    end

    #-rem alla will remove all known ancillary chunks
    def self.squeeze(filename, output_filename)
      system("pngcrush -rem alla -brute -reduce #{filename} #{output_filename} > /dev/null")
    end
  end
end