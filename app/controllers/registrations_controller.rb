class RegistrationsController < Devise::RegistrationsController
    def create
        @user = User.new(user_params)
        if @user.save
            sign_in(@user)
            redirect_to account_teams_url(subdomain: current_user.company.subdomain)
        else
            render :new
        end
    end

    private
  
    def user_params
      params.require(:user).permit(:first_name, :last_name,:email, :password, :password_confirmation, :company_id)
    end
end