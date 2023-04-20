Rake::Task['assets:precompile'].enhance ['yarn:install'] if Rake::Task.task_defined?('assets:precompile') && Rails.root.join('bin', 'yarn').exist?
