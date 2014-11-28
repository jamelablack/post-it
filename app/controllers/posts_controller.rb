class PostsController < ApplicationController::Base
  def index

  end

  def show
  	@post = Post.find(params[:id])

  end
end
