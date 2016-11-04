class Sentence < ApplicationRecord
  belongs_to :publication
  has_many :similar, class_name:  "Similarity",
                                  foreign_key: "original_id",
                                  dependent:   :destroy

  def percentage_max_score
      maximum = self.publication.sentences.where.not('max_score' => nil).order("max_score DESC").first.max_score
      own_score = self.max_score

    return (own_score / maximum) rescue 0
  end
end
