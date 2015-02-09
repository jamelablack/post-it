class UsersController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update]
	before_action :require_same_user, only: [:edit, :udpate]
 
	def new
		@user = User.new

	end

	def create
		@user = User.new(user_params)

		if @user.save
			session[:user_id] = @user.id
			flash[:notice] = "You're now registered"
			redirect_to root_path
		else
			render :new
		end
	end

	def show
	end

	def edit
	end


	def update
		if @user.update(user_params)
			flash[:notice] = "Your user profile has been updated"
			redirect_to user_path(@user)
		else
			render :edit
		end

	end


	private
	def user_params
		params.require(:user).permit(:username, :password, :time_zone)

	end

	def set_post
		@user = User.find_by slug: params[:id]
	end

	def require_same_user
		if current_user != @user
			flash[:error] = "You are not allowed to complete that action!"
			redirect_to root_path
		else
			render :edit
		end
	end
end


