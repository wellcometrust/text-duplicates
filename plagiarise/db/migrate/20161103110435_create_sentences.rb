class CreateSentences < ActiveRecord::Migration[5.0]
  def change
    create_table :sentences do |t|
      t.text :text
      t.references :publication, foreign_key: true

      t.timestamps
    end
  end
end
