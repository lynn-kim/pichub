class CreateJoinTableCartImage < ActiveRecord::Migration[6.1]
  def change
    create_join_table :carts, :images do |t|
      t.index [:cart_id, :image_id]
      # t.index [:image_id, :cart_id]
    end
  end
end
