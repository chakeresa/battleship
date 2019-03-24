# instructions from http://backend.turing.io/module1/lessons/project_etiquette
# may have to do `gem install rake`
# just run `rake` from the terminal to execute all tests
#    (as if it were one, big test file)!

require 'rake/testtask'

Rake::TestTask.new do |t|
    t.pattern = "test/**/*_test.rb"
end

task default: ["test"]
