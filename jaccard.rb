require 'similarity_matrix'

class Jaccard
  attr_accessor :similarities
  
  def initialize(subscriptions)
    @subscriptions = subscriptions
    @similarities = SimilarityMatrix.new(@subscriptions, Proc.new {|a,b| Jaccard.coefficient(a,b) })
  end

  # returns weights for each person other_users are subscribed to.
  # the guess value is higher if many other_users follow them.
  # other_users count most if they're similar to you,
  # as calculated by how much the people you follow overlap
  def generate_recommendations_for(target_user, other_users)
    recos     = {}
    
    other_users.each do |user_id|
      similarity = @similarities.find(target_user,user_id)
      @subscriptions[user_id].each do |recommendation|
        if recos.has_key?(recommendation)
          recos[recommendation] += similarity
        else
          recos[recommendation] = similarity
        end
      end
    end
    
    recos
  end
  
  def recommendations_for(target_user)
    # generate a hash of all the users 1 degree away from you in the social network
    other_users = (@subscriptions[target_user] - [target_user])
    
    recos = generate_recommendations_for(target_user, other_users)
    
    # ignore people you're already subscribed to
    recos.delete_if {|k,v| @subscriptions[target_user].include?(k)}
    
    # normalize data to max 1
    total_similarity = other_users.collect {|user_id| @similarities.find(target_user, user_id) }.sum.to_f
    self.class.normalize(recos, 1, total_similarity)
  end
  
  # see http://en.wikipedia.org/wiki/Jaccard_index
  def self.coefficient(a,b)
    result = (a & b).length / (a + b).uniq.length.to_f
    (result * 1000).round / 1000.0
  end
  
  def self.normalize(data,max,divisor)
    return data if divisor == 0
    data.keys.each do |key|
      data[key] /= divisor
    end
    data
  end
end