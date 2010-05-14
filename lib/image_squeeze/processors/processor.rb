require 'tempfile'

class ImageSqueeze
  class Processor
    attr_reader :filename
    
    def self.tmp_filename(filename)
      t = Time.now.strftime("%Y%m%d")
      path = "#{File.basename(filename)}#{t}-#{$$}-#{rand(0x100000000).to_s(36)}"
         
      File.join(Dir::tmpdir, path)
    end
    
    def self.squeeze_to_tmp(filename)
      tmp = tmp_filename(filename)
      squeeze(filename, tmp)
      tmp
    end
    
    def self.squeeze(filename, output_filename)
      raise "Should be defined in subclass and should convert filename to something at output_filename"
    end
    
    def self.input_type
      raise "Should be defined in subclass"
    end
    
    # override if you want a different output extensions
    def self.output_extension
      ImageSqueeze::IMAGE_TYPE_TO_EXTENSION[input_type]
    end
  end
end