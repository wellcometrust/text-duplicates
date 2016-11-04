class CreateSimilarities < ActiveRecord::Migration[5.0]
  def change
    create_table :similarities do |t|
      t.float :score
      t.text :highlight
      t.integer :original_id
      t.integer :similar_id

      t.timestamps
    end
  end
end
