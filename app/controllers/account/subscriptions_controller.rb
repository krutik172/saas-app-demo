class Account::SubscriptionsController < Account::ApplicationController
    
  def choose_plan
    StripeChargeService.new(current_user, current_user.subscription ,view_context).call
    checkout_url = StripeChargeService.new(current_user, current_user.subscription ,view_context).call.url
    redirect_to checkout_url
  end
  
  def stripe_success
    respond_to do |format|
      current_user.subscription.update(plan: "premium")
      format.html { redirect_to root_url, notice: I18n.t("projects.notifications.plans_successful") }
    end
  end

  def stripe_cancel
    respond_to do |format|
      format.html { redirect_to root_url, notice: I18n.t("projects.notifications.plans_unsuccessful") }
    end
  end
end
  