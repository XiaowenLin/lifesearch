class Sprint < ActiveRecord::Base
  # make all attr accessible
  attr_protected
  # validate entries
  validates :name, :presence => true
end
