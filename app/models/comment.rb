class Comment < ActiveRecord::Base
  attr_accessible :content, :commentable_id, :commentable_type

  belongs_to :commentable, polymorphic: true
end
