require 'similarity_matrix'

class Jaccard
  attr_accessor :similarities
  
  def initialize(user_hash)
    @user_hash = user_hash
    @similarities = SimilarityMatrix.new(@user_hash) do |a,b| 
      Jaccard.coefficient(a,b)
    end
  end
  
  def recommendations_for(user_key)
    recos, total_similarity = {}, 0
    
    (@user_hash[user_key] - [user_key]).each do |following|
      next if @user_hash[following].nil?
      similarity = @similarities.find(user_key,following)
      total_similarity += similarity
      @user_hash[following].each do |recommendation|
        if recos.has_key?(recommendation)
          recos[recommendation] += similarity
        else
          recos[recommendation] = similarity
        end
      end
    end
    
    return {} if total_similarity == 0
    
    recos.delete_if {|k,v| @user_hash[user_key].include?(k)}
    recos.keys.each do |key|
      recos[key] /= total_similarity #normalize data to max 1
    end
    
    recos
  end
  
  def self.coefficient(a,b)
    result = (a & b).length / (a + b).uniq.length.to_f
    (result * 1000).round / 1000.0
  end
end