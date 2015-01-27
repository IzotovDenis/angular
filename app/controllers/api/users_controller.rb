class Api::UsersController < ApiController
  before_action :set_user, only: [:index, :update, :update_password]
  respond_to :json

  def index
  end

  def update
    if @user.update(user_params)
      @status = true
    else
      @status = false
    end
  end

  def update_password
    if @user.valid_password?(params[:pswd][:old])
      @user.password = params[:pswd][:pass]
      @user.password_confirmation = params[:pswd][:confirm]
      @user.save
      sign_in(@user, :bypass => true)
    else
      @user.errors.add(:password, :invalid)
    end
  end

  def current
  	@user = current_user
  	if @user
    	respond_with @user
    else
		render nothing: true, status: :unauthorized
    end
  end

  protected

  def set_user
    @user = current_user 
  end

  def user_params
    @params = params.require(:user).permit( :person,
                                            :phone, 
                                            :city, 
                                            :name, 
                                            :legal_address,
                                            :actual_address, 
                                            :kpp, 
                                            :bank_name, 
                                            :curr_account, 
                                            :corr_account,
                                            :bik,
                                            :ogrn,
                                            :note)
  end

end