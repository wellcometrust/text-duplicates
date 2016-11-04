class Similarity < ApplicationRecord
  belongs_to :original, class_name: "Sentence"
  belongs_to :similar, class_name: "Sentence"
end
