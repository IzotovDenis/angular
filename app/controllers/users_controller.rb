# coding: utf-8
class UsersController < ApplicationController
  load_and_authorize_resource
	before_action :set_user, only: [:show, :edit, :update, :destroy, :update_role]
  def index
  	@users = User.all.order("created_at ASC")
  	@roles = [[ "Пользователь","user"],
			[ "Покупатель","buyer"],
			[ "Супер покупатель","superbuyer"]]
  end	

  def show
    
  end

  def edit
    
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, notice: 'Validation' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_role
    @user.update_attribute('role', params[:user][:role])
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:person, :city, :inn, :name, :legal_address, :actual_address,
        :kpp, :bank_name,:curr_account,:corr_account,:bik, :phone, :note, :ogrn )
    end

    def user_params_role
      params.require(:user).permit(:role)
    end
end

