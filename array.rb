class Array
  def histogram
    inject(Hash.new(0)) do |memo,value|
      memo[value] += 1
      memo
    end
  end
end