require File.join(File.dirname(__FILE__), '..', 'test_helper')

class UtilsTest < Test::Unit::TestCase
  def test_utility_available_returns_true_when_found
    assert ImageSqueeze::Utils.image_utility_available?('ls', 'files'), "You don't have ls, wtf?"
  end

  def test_utility_available_returns_false_when_not_found
    ImageSqueeze.logger.stubs(:warn)
    assert !ImageSqueeze::Utils.image_utility_available?('andrewMagicNonexistantFileDestroyer', 'magic'), "Uhhh...where'd you get that?"
  end
  
  def test_utility_logs_warning_when_not_found
    ImageSqueeze.logger.expects(:warn).with(regexp_matches(/marbles/))
    ImageSqueeze::Utils.image_utility_available?('andrewMagicNonexistantFileDestroyer', 'marbles')
  end
  
  def test_utility_available_raises_when_not_found_and_raise_when_missing_true
    ImageSqueeze.logger.stubs(:error)
    assert_raises StandardError do
      !ImageSqueeze::Utils.image_utility_available?('andrewMagicNonexistantFileDestroyer', 'magic', true)
    end
  end

  def test_utility_logs_error_when_missing_true
    ImageSqueeze.logger.expects(:error)
    ImageSqueeze::Utils.image_utility_available?('andrewMagicNonexistantFileDestroyer', 'dolphins', true) rescue StandardError
  end
end