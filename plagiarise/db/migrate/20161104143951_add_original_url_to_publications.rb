class AddOriginalUrlToPublications < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, :original_url, :string
  end
end
