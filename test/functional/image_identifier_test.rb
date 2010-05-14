require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ImageTypeTest < Test::Unit::TestCase
  def test_image_type_not_found_when_no_file
    image_type = ImageSqueeze.image_type('blah.jpg')
    assert_equal ImageSqueeze::NOT_FOUND, image_type
  end
  
  def test_image_type_correctly_identifies_gif
    image_type = ImageSqueeze.image_type(fixtures('already_optimized_gif.gif'))
    assert_equal ImageSqueeze::GIF, image_type
  end
  
  def test_image_type_correctly_identifies_animated_gif
    image_type = ImageSqueeze.image_type(fixtures('unoptimized_animated_gif.gif'))
    assert_equal ImageSqueeze::ANIMATED_GIF, image_type
  end

  def test_image_type_correctly_identifies_png
    image_type = ImageSqueeze.image_type(fixtures('already_optimized_png.png'))
    assert_equal ImageSqueeze::PNG, image_type
  end

  def test_image_type_correctly_identifies_jpeg
    image_type = ImageSqueeze.image_type(fixtures('already_optimized_jpg.jpg'))
    assert_equal ImageSqueeze::JPEG, image_type
  end
  
  def test_image_type_correctly_identifies_non_images
    image_type = ImageSqueeze.image_type(fixtures('textfile.txt'))
    assert_equal ImageSqueeze::UNKNOWN, image_type
  end
  
  def test_image_type_correctly_identifies_image_with_wrong_extension
    image_type = ImageSqueeze.image_type(fixtures('mislabeled_gif.png'))
    assert_equal ImageSqueeze::GIF, image_type
  end
  
end