class CreateReader < ActiveRecord::Migration[7.0]
  def change
    create_table :readers do |t|
      t.string :book_ids, array: true

      t.timestamps
    end
  end
end
