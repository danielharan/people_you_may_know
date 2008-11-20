require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'combinations')
require 'jaccard'

class SimilarityMatrix
  
  def initialize(hash_of_users, &block)
    raise ArgumentError.new("Matrix needs a block to compute similarities") unless block_given?
    @similarities = Combinations.get(hash_of_users.keys.size, 2).inject({}) do |memo,indexes|
      key1, key2 = hash_of_users.keys[indexes.first],   hash_of_users.keys[indexes.last]
      val1, val2 = hash_of_users.values[indexes.first], hash_of_users.values[indexes.last]
      
      memo[[key1,key2].sort] = yield(val1,val2)
      memo
    end
  end
  
  def find(user,other_user)
    @similarities[[user,other_user].sort]
  end
end