require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ImageIdentifierTest < Test::Unit::TestCase
  def test_image_type_not_found_when_no_file
    identifier = ImageSqueeze::ImageIdentifier.new('blah.jpg')
    assert_equal ImageSqueeze::NOT_FOUND, identifier.image_type
  end
  
  def test_identifier_correctly_identifies_gif
    identifier = ImageSqueeze::ImageIdentifier.new(fixtures('already_optimized_gif.gif'))
    assert_equal ImageSqueeze::GIF, identifier.image_type
  end
  
  def test_identifier_correctly_identifies_animated_gif
    identifier = ImageSqueeze::ImageIdentifier.new(fixtures('unoptimized_animated_gif.gif'))
    assert_equal ImageSqueeze::ANIMATED_GIF, identifier.image_type
  end

  def test_identifier_correctly_identifies_png
    identifier = ImageSqueeze::ImageIdentifier.new(fixtures('already_optimized_png.png'))
    assert_equal ImageSqueeze::PNG, identifier.image_type
  end

  def test_identifier_correctly_identifies_jpeg
    identifier = ImageSqueeze::ImageIdentifier.new(fixtures('already_optimized_jpg.jpg'))
    assert_equal ImageSqueeze::JPEG, identifier.image_type
  end
  
  def test_identifier_correctly_identifies_non_images
    identifier = ImageSqueeze::ImageIdentifier.new(__FILE__)
    assert_equal ImageSqueeze::UNKNOWN, identifier.image_type
  end
  
  def test_identifier_correctly_identifies_image_with_wrong_extension
    identifier = ImageSqueeze::ImageIdentifier.new(fixtures('mislabeled_gif.png'))
    assert_equal ImageSqueeze::GIF, identifier.image_type
  end
  
end