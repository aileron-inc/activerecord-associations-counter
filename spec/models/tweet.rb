class Tweet < ActiveRecord::Base
  has_many :favorites
  has_many_count :favorites
end
