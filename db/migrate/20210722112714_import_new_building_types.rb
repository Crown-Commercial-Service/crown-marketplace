class ImportNewBuildingTypes < ActiveRecord::Migration[6.0]
  def up
    Rake::Task['db:rm3830:buildings'].invoke
  end

  def down; end
end
