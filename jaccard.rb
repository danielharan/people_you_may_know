require 'similarity_matrix'

class Jaccard
  attr_accessor :similarities
  
  def initialize(user_hash)
    @similarities = SimilarityMatrix.new(user_hash) do |a,b| 
      Jaccard.coefficient(a,b)
    end
  end
  
  def self.coefficient(a,b)
    result = (a & b).length / (a + b).uniq.length.to_f
    (result * 1000).round / 1000.0
  end
end