class CreatePublications < ActiveRecord::Migration[5.0]
  def change
    create_table :publications do |t|
      t.string :title
      t.string :author
      t.string :year
      t.string :wellcome_id

      t.timestamps
    end
  end
end
