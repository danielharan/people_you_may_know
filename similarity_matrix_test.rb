require "test/unit"

require "similarity_matrix"

class TestSimilarityMatrix < Test::Unit::TestCase
  def setup
    prefs_hash = {
        '330' => ["250", "276", "330", "724", "739"], 
        '250' =>["213", "228", "250", "276", "290", "326", "330", "489", "531", "572", "579", "688", "724", "739"]
    }
    @sm = SimilarityMatrix.new(prefs_hash) do |a,b| 
      Jaccard.coefficient(a,b)
    end
  end
  
  def test_init_should_raise_if_no_block_given
    begin
      SimilarityMatrix.new({})
      flunk "should have required a block"
    rescue ArgumentError => e
      assert /block/ =~ e.message, "message should tell user to pass a block"
    end
  end
  
  def test_init
    assert_not_nil @sm
  end
  
  def test_order_of_keys
    assert_equal 0.357, @sm.find('250', '330')
    assert_equal 0.357, @sm.find('330', '250')
  end
end