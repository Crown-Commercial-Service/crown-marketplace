class Addpostcodelocatorindex < ActiveRecord::Migration[5.2]
  def change
    add_index :os_address, :postcode_locator
  end
end
