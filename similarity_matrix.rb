require 'jaccard'

class SimilarityMatrix
  
  def initialize(hash_of_users, proc)
    @similarities = {}
    @hash_of_users, @proc = hash_of_users, proc
  end
  
  def find(user,other_user)
    return @similarities[[user,other_user].sort] unless @similarities[[user,other_user].sort].nil?
    
    @similarities[[user,other_user].sort] = @proc.call(@hash_of_users[user], @hash_of_users[other_user])
  end
end