require "test/unit"

require "similarity_matrix"

class TestSimilarityMatrix < Test::Unit::TestCase
  def setup
    prefs_hash = {
        '330' => ["250", "276", "330", "724", "739"], 
        '250' =>["213", "228", "250", "276", "290", "326", "330", "489", "531", "572", "579", "688", "724", "739"]
    }
    @sm = SimilarityMatrix.new(prefs_hash, Proc.new {|a,b| Jaccard.coefficient(a,b)})
  end
  
  def test_init
    assert_not_nil @sm
  end
  
  def test_order_of_keys
    assert_equal 0.357, @sm.find('250', '330')
    assert_equal 0.357, @sm.find('330', '250')
  end
end