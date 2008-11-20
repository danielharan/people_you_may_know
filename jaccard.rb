class Jaccard
  def self.coefficient(a,b)
    result = (a & b).length / (a + b).uniq.length.to_f
    (result * 1000).round / 1000.0
  end
end