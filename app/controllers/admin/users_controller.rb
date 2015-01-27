class Admin::UsersController < AdminController
	respond_to :html, :json
	before_action :set_user, only: [:show, :edit, :update, :destroy, :reset_password]
	def index
		@users = User.all
	end

	def show
	end

  def update
  	@user.update(user_params)
    respond_with @user
  end

  def reset_password
  	@password = @user.reset_password
  	UserMailer.reset_password(@user, @password).deliver
  	redirect_to admin_users_path
  end

	def destroy
		@user.destroy
		redirect_to admin_users_path
	end

	private

		def set_user
			@user = User.find(params[:id])
		end
	def user_params
      params.require(:user).permit(:person, :city, :inn, :name, :legal_address, :actual_address,
        :kpp, :bank_name,:curr_account,:corr_account,:bik, :phone, :note, :ogrn, :role )
    end
end