class AddMaxScoreToSentences < ActiveRecord::Migration[5.0]
  def change
    add_column :sentences, :max_score, :float
  end
end
