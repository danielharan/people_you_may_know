require 'test/unit'
require 'jaccard'

class JaccardTest < Test::Unit::TestCase
  def setup
    @jaccard = Jaccard.new({
      '330' => ["250", "276", "330", "724", "739"], 
      '250' =>["213", "228", "250", "276", "290", "326", "330", "489", "531", "572", "579", "688", "724", "739"]})
  end
  
  def test_initialize
    assert_not_nil @jaccard
  end
  
  def test_similarity
    assert_equal 0.357, @jaccard.similarities.find("250", "330")
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