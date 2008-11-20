require 'test/unit'
require 'jaccard'

class JaccardTest < Test::Unit::TestCase

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