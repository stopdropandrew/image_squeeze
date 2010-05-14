module ImageSqueeze
  def image_type(filename)
    return ImageSqueeze::NOT_FOUND unless File.exist?(filename)
    
    case identified_format(filename)
    when /^GIFGIF/
      ImageSqueeze::ANIMATED_GIF
    when /GIF/
      ImageSqueeze::GIF
    when /JPEG/
      ImageSqueeze::JPEG
    when /PNG/
      ImageSqueeze::PNG
    else
      ImageSqueeze::UNKNOWN
    end
      
  end
  module_function :image_type
  
  private
  def identified_format(filename)
    `identify -format %m #{filename}`
  end
  module_function :identified_format
end
  