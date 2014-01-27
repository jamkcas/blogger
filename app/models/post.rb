class Post < ActiveRecord::Base
  attr_accessible :title, :content

  has_many :comments, as: :commentable
end
