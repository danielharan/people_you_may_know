require 'rubygems'
require 'test/unit'
require './array'

class ArrayTest < Test::Unit::TestCase
  def test_histogram
    target = {1 => 'a', 2 => 'b', 3 => 'a'}
    assert_equal ({'a' => 2, 'b' => 1}), target.values.histogram
  end
  
  def test_with_nil
    target = {'one' => 'a', 'two' => nil, 'three' => nil}
    assert_equal ({'a' => 1, nil => 2}), target.values.histogram
  end
end