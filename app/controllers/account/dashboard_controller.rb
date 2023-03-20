class Account::DashboardController < Account::ApplicationController
  def index
    redirect_to account_teams_url(subdomain: current_user.company.subdomain)
  end
end
