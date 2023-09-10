class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :name
      t.string :age
      t.text :about

      t.timestamps
    end
  end
end
