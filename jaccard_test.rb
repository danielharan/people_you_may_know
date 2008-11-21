require 'test/unit'
require 'jaccard'
require 'rubygems'
require 'activesupport'

class JaccardTest < Test::Unit::TestCase
  def setup
    @jaccard = Jaccard.new({
      "250" => ["213", "228", "250", "276", "290", "326", "330", "489", "531", "572", "579", "688", "724", "739"],
      "276" => ["228", "250", "276", "326"],
      "330" => ["250", "276", "330", "724", "739"],
      "724" => ["60", "149", "177", "191", "213", "228", "250", "262", "326", "336", "572", "579", "688", "697", "724", "739", "783", "849", "860", "968", "997", "1827", "1914", "2008", "3143"],
      "739" => ["213", "228", "250", "330", "724", "739", "860", "3509", "16987", "16990"]})
  end
  
  def test_initialize
    assert_not_nil @jaccard
  end
  
  def test_similarity
    assert_equal 0.357, @jaccard.similarities.find("250", "330")
  end
  
  def test_recommendations
    recos = @jaccard.recommendations_for("330")
    assert_not_nil recos
    #puts recos.to_a.sort_by(&:last).reverse.inspect
    assert recos.keys.include?("228") # followed by all other users
    assert recos["228"] > recos["60"], "user 60 is only followed by 1 person, so should be lower than 228"
  end
  
  def test_recommendation_should_be_zeros_if_absolutely_no_overlap
    jaccard = Jaccard.new({
      "1" => ["2", "3"],
      "2" => ["4", "5"],
      "3" => ["6", "7"]})
    assert_equal ({"4" => 0, "5" => 0, "6" => 0, "7" => 0}), jaccard.recommendations_for("1")
  end
    
  def test_normalizes_from_0_to_1
    recos = @jaccard.recommendations_for("330")
    assert !recos.has_key?("250"), "should not recommend someone you're already subscribed to"
    
    assert recos.values.max <= 1, "values should be normalized"
    
    assert_equal 1.0, recos["228"], "everyone else follows 228, so it should return 1"
  end
  
  def test_coefficient_output
    {
      [[1,2,3],[1,2,3]] => 1,
      [[1,2,3],[1,2]]   => 0.667,
      [[1,2,3],[1,2,4]] => 0.5,
      [[1,2,3],[4,5,6]] => 0
    }.each_pair do |key,expected_value|
      assert_equal expected_value, Jaccard.coefficient(*key)
    end
  end
  
  
end