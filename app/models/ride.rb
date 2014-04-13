class Ride < ActiveRecord::Base
  belongs_to :driver
  belongs_to :rider
  belongs_to :rating
end
