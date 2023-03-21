namespace :db do
  desc 'add static data to the database'
  task setup: :static
end
