class SessionsController < ApplicationController

	def new

	end


	def create
		user = User.where(username: params[:username]).first
		if user && user.authenticate(params[:password])
			if user.two_factor_auth?
				session[:two_factor] = true
				#generate a pin
				user.generate_pin!
				#send pin to twilio, sms user's phone
				user.send_pin_to_twilio

				#show pin form for user input after sms
				redirect_to pin_path

		else
			login_user!(user)
		end
	else
			flash[:error] = "There is something with your username & password."
			redirect_to login_path
		end
	
	end


	def destroy
		session[:user_id] = nil
		flash[:notice] = "You've logged out."
		redirect_to root_path
	end

	def pin
		access_denied if session[:two_factor].nil?
		if request.post?
		  user = User.find_by(pin: params[:pin])
		  if user
		  	session[:two_factor] = nil
		    #remove pin
		    user.remove_pin!
		    #normal login success route
				login_user!(user)
		  else
		    flash[:error] = "Sorry, something is wrong with the pin you've entered."
		    redirect_to pin_path
	   	end
	  end  
  end	

  private

  def login_user!(user)
  		session[:user_id] = user.id
			flash[:notice] = "Welcome, you've logged in."
			redirect_to root_path
	end

end