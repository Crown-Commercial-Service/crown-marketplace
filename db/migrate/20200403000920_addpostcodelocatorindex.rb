class Addpostcodelocatorindex < ActiveRecord::Migration[5.2]
  def up
    add_index :os_address, :postcode_locator unless index_exists?(:os_address, :postcode_locator)
  end

  def down
    remove_index :os_address, :postcode_locator if index_exists?(:os_address, :postcode_locator)
  end
end
