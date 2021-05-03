class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.decimal :price
      t.integer :discount
      t.string :tags
      t.boolean :private

      t.timestamps
    end
  end
end
