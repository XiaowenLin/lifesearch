class User < ActiveRecord::Base
  has_many :sprints
  attr_accessible :name, :provider, :uid
  def self.create_with_omniauth(auth)
    User.create!(
      :provider => auth["provider"],
      :uid => auth["uid"],
      :name => auth["info"]["name"])
  end
end
