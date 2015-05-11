task :default => ["spec:develop"]

namespace :spec do
  require './spec/rake_rspec'

  rspec_task(:unit) do
    exclude_tags :integration
  end

  rspec_task(:develop) do
  end

  rspec_task(:ci) do
    add_opts "--color -fd"
  end
end
