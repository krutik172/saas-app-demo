class Account::CompaniesController < Account::ApplicationController

    def new
        @company = Company.new
    end

    def create
        @company = Company.create(company_params)
        @company.subdomain = @company.name.split.first.downcase if  @company.name.present?
        if current_user
            current_user.update(company_id: @company.id)
        end
        if @company.save
            redirect_to account_teams_url(subdomain:  @company.subdomain) 
        else
           render :new
        end
    end

    def show
        @company = Company.find(params[:id])
    end

    private
    def company_params
        params.require(:company).permit(:name, :email, :subdomain)
    end
end