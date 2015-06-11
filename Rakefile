task :default => ["spec:develop"]

namespace :spec do
  require './spec/rake_rspec'

  desc 'Runs unit tests'
  rspec_task(:unit) do
    exclude_tags :integration
  end

  desc 'Runs all the tests that provide fast feedback'
  rspec_task(:develop) do
  end

  desc 'Runs the all the tests for continuous integration'
  rspec_task(:ci) do
    add_opts "--color -fd"
  end
end
