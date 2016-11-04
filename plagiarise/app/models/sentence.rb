class Sentence < ApplicationRecord
  belongs_to :publication

  def percentage_max_score
      maximum = self.publication.sentences.order("max_score DESC").first.max_score
      own_score = self.max_score

    return (own_score / maximum) rescue 0
  end

  def css_style
    return "background-color: rgba(255, 0, 0, 0.5)"
  end
end
