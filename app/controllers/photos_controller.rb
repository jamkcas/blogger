class PhotosController < ApplicationController
  def create
    @photo = Photo.create(title: params[:title], image: params[:image])
    render json: { title: @photo.title, image: @photo.image, id: @photo.id }
  end
end
