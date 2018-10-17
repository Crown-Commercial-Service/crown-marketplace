class ChangeJobTypeStringToText < ActiveRecord::Migration[5.2]
  def change
    change_column :rates, :job_type, :text, null: false
  end
end
