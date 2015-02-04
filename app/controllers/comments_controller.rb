class CommentsController < ApplicationController
before_action :require_user
	def create
		@post = Post.find_by slug: params[:post_id]
		@comment = @post.comments.build(params.require(:comment).permit(:body))
		@comment.creator = current_user #TODO: Fix upon adding authentication


		if @comment.save
			flash[:notice] = "Your comment has been added!"
			redirect_to post_path(@post)
		else
			render 'posts/show'
		end

	end
		def vote
			@comment = Comment.find(params[:id])
			@vote = Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])
		respond_to do |format|
			format.html do
				if @vote.valid?
					flash[:notice] = "You're vote was counted!"
				else
					flash[:error] = "You're only allowed to vote once."	
				end
				redirect_to :back
			end
			format.js
			end
		end
	

	end


