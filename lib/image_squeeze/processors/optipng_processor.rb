class ImageSqueeze
  class OptiPNGProcessor < Processor
    def self.input_type
      PNG
    end
    
    def self.squeeze(filename, output_filename)
      system("optipng -i1 -o7 #{filename} -out=#{output_filename} > /dev/null")
    end
  end
end