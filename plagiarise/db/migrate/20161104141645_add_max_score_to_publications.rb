class AddMaxScoreToPublications < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, :max_score, :float
  end
end
