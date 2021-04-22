namespace :db do
  namespace :migrate do
    desc 'Run db:migrate but ignore ActiveRecord::ConcurrentMigrationError errors update'
    # rubocop:disable Style/RedundantBegin
    task ignore_concurrent: :environment do
      begin
        Rake::Task['db:migrate'].invoke
      rescue ActiveRecord::ConcurrentMigrationError
        # Do nothing
      end
    end
    # rubocop:enable Style/RedundantBegin
  end
end
