class FixLatLongInDb < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL.squish
      UPDATE branches
      SET location = ST_Point(ST_Y(location::geometry), ST_X(location::geometry))
      WHERE ST_Y(location::geometry) < 40
    SQL
  end
end
