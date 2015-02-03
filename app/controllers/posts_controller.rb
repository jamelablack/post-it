class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :create]
  def index
  	@posts = Post.all.sort_by{|x| x.total_votes}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
	end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user 

    if @post.save(post_params)
      flash[:notice] = "Your post has been saved!"
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "Your post has been updated!"
      redirect_to posts_path
    else
      render 'edit'
    end
  end


  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html do
        if vote.valid?
          flash[:notice] = "Your vote was counted!"
        else
          flash[:error] = "Your vote was <strong>not</strong> recorded!".html_safe  
        end  
        redirect_to :back 
      end
      format.js 
    end
  end

private
  def post_params
    params.require(:post).permit(:title, :url, :description)
  end 
  
  def set_post
    @post = Post.find(params[:id])
  end 

end
