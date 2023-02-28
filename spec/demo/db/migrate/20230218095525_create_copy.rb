class CreateCopy < ActiveRecord::Migration[7.0]
  def change
    create_table :copies do |t|
      t.integer :book_id

      t.timestamps
    end
  end
end
