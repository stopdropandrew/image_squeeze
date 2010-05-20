class ImageSqueeze
  class Processor
    attr_reader :filename
    
    def self.squeeze(filename, output_filename)
      raise "#{to_s}#squeeze should be defined in subclass and should convert filename to something at output_filename"
    end
    
    def self.handles?(image_type)
      image_type == input_type
    end
    
    def self.input_type
      raise "#{to_s}#input_type should be defined in subclass"
    end
    
    # override if you want a different output extensions
    def self.output_extension
      ImageSqueeze::IMAGE_TYPE_TO_EXTENSION[input_type]
    end
  end
end