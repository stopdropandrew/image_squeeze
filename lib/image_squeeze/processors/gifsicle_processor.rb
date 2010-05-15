class ImageSqueeze
  class GifsicleProcessor < Processor
    def self.input_type
      ANIMATED_GIF
    end
    
    def self.squeeze(filename, output_filename)
      system("gifsicle -O2 #{filename} > #{output_filename} 2> /dev/null")
    end
  end
end