require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'engine_cart/rake_task'

RSpec::Core::RakeTask.new(:spec)

task ci: ['engine_cart:generate', :spec]
task default: [:ci]
