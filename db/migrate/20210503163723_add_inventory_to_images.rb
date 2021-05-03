class AddInventoryToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :inventory, :integer
  end
end
