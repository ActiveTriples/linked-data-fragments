# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'Run CI'
task :ci do
  sh 'cp config/ldf.yml.sample_repository config/ldf.yml'
  Rake::Task['spec'].invoke
end
