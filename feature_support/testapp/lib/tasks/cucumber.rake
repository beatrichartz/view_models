require 'cucumber/rake/task'

namespace :cucumber do
  Cucumber::Rake::Task.new({:ok => 'db:test:prepare'}, 'Run features that should pass') do |t|
    t.fork = true # You may get faster startup if you set this to false
    t.profile = 'default'
  end

  Cucumber::Rake::Task.new({:wip => 'db:test:prepare'}, 'Run features that are being worked on') do |t|
    t.fork = true # You may get faster startup if you set this to false
    t.profile = 'wip'
  end

  Cucumber::Rake::Task.new({:rerun => 'db:test:prepare'}, 'Record failing features and run only them if any exist') do |t|
    t.fork = true # You may get faster startup if you set this to false
    t.profile = 'rerun'
  end

  desc 'Run all features'
  task :all => [:ok, :wip]

  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << %w(Cucumber\ features features) if File.exist?('features')
    ::CodeStatistics::TEST_TYPES << "Cucumber features" if File.exist?('features')
  end
end

task :cucumber => 'cucumber:all'

task :default => :cucumber
