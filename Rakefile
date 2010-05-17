require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'lib/image_squeeze'

desc "Run all tests"
task 'default' => ['test:functionals']

namespace 'test' do
  functional_tests = FileList['test/functional/**/*_test.rb']

  desc "Run functional tests"
  Rake::TestTask.new('functionals') do |t|
    t.libs << 'test'
    t.test_files = functional_tests
    t.verbose = true
    t.warning = false
  end
end

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "a library for automated lossless image optimization"
  s.name = 'image_squeeze'
  s.version = ImageSqueeze::VERSION
  s.requirements << 'none'
  s.require_path = 'lib'
  s.files = FileList[
      "lib/**/*", "test/**/*", "[a-zA-Z]*"
  ].exclude(/\.gitignore/)
  s.description = "a library for automated lossless image optimization"
  s.homepage = "http://github.com/stopdropandrew/image_squeeze"
  s.author = "Andrew Grim"
  s.email = "stopdropandrew@gmail.com"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end