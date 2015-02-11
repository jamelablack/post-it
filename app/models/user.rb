class User < ActiveRecord::Base
	include Sluggable
	has_many :posts
	has_many :comments 
	has_many :votes

	has_secure_password validations: false

	validates :username, presence: true, uniqueness: true
	validates :password, presence: true, on: :create, length: {minimum: 5}
	
	sluggable_column :username

	def admin?
		self.role == 'admin'
	end

	def moderator?
		self.role == 'moderator?'
	end


	def two_factor_auth?
		!self.phone.blank?
	end

	def generate_pin!
		self.update_column(:pin, rand(10 ** 6)) #generate a random six digit number
	end

	def remove_pin!
		self.update_column(:pin, nil)
	end

	def send_pin_to_twilio
		account_sid ='AC47bdb7f569ae31aa59309f81981aaf37'
		auth_token = 'f3d9c378bba9272d3ed9fec659e353b0'

		# set up a client to talk to the Twilio REST API 
		client = Twilio::REST::Client.new account_sid, auth_token 
		msg = "Hello, Please enter this pin to continue login: #{self.pin}."
		account = client.account
		message = account.sms.messages.create({
			:from => '+13392985371', 
			:to => '202-809-8486',
			:body => msg,   
		})

	end
end
