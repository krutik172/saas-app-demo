class Account::SubscriptionsController < Account::ApplicationController

    def choose_plan
      StripeChargeService.new(current_user, current_user.subscription ,view_context).call
      checkout_url = StripeChargeService.new(current_user, current_user.subscription ,view_context).call.url
      redirect_to checkout_url
    end  
end
  