class UsersController < ApplicationController
	def create
    @user = User.new(user_params)
    
    if @user.save
      # Generate OTP
      otp_code = rand(1000..9999) # Generate a 4-digit OTP code
      @user.update(otp_code: otp_code)  # Make sure to add this attribute to the User model.
      TwilioService.new(@user.phone_number.to_s).send_verification_code(otp_code)

      render json: { message: 'OTP sent to phone' }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/users/verify
  def verify
    @user = User.find_by(phone_number: params[:phone_number])
    
    if @user && params[:otp_code].to_s == @user.otp_code.to_s
      @user.update(verified: true)  # Add 'verified' column to your User model.
      render json: { message: 'Phone verified successfully' }, status: :ok
    else
      render json: { message: 'Invalid verification code' }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :digested_password, :user_type, :authentication_type, :country_code, :phone_number)
  end
end
