require 'rake/testtask'

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
