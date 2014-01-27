class CommentsController < ApplicationController
  def create
    @comment = Comment.create(content: params[:content], commentable_id: params[:commentable_id], commentable_type: params[:commentable_type])
    render json: { content: @comment.content, commentable_id: @comment.commentable_id, commentable_type: @comment.commentable_type}
  end
end
