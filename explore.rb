require 'rubygems'
require 'activesupport'
require 'jaccard'

class ResultDatum
  attr_accessor :user_id, :excluded_subscription, :recommendations
  def initialize(user_id, excluded_subscription, recommendations)
    @user_id, @excluded_subscription, @recommendations = user_id, excluded_subscription, recommendations
  end
end

sub = File.open("identica_data/subscriptions.txt").read.split("\n")[1..-1].collect do |line|
  line.split("\t")[0..1]
end

subscriptions = sub.inject(Hash.new {|hash,key| [] }) do |memo,kp|
  memo[kp.first] = (memo[kp.first] << kp.last)
  memo
end

jaccard = Jaccard.new(subscriptions) # use full set to compute similarities

(2..12).each do |num_subscribers|
  median_users = subscriptions.select {|k,v| num_subscribers == (v - [k]).length }

  results = []
  median_users.each do |target,other_users|
    other_users -= [target]
    other_users -= [(excluded = other_users.rand)] # do this on 2 lines, to avoid removing target as the random user
  
    results << ResultDatum.new(target, excluded, jaccard.generate_recommendations_for(target, other_users))
  end

  matches = results.inject(0) {|memo, datum| datum.recommendations.keys.include?(datum.excluded_subscription) ? memo + 1 : memo }
  
  puts "[#{num_subscribers} subscriptions] #{matches} / #{median_users.length} users get recommendations that include a removed user "
end
