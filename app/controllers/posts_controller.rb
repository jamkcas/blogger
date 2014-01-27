class PostsController < ApplicationController
  def index
    @posts = Post.includes(:comments).all + Photo.includes(:comments).all

    @posts.sort! {|a, b| b.created_at <=> a.created_at}

    respond_to do |format|
      format.html
      format.json { render json: @posts, include: :comments }
    end

  end

  def create
    @post = Post.create(title: params[:title], content: params[:content])
    render json: { title: @post.title, content: @post.content, id: @post.id }
  end
end
