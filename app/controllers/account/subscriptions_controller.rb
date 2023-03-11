class Account::SubscriptionsController < Account::ApplicationController

    def choose_plan
      plan = params[:plan]
      qty = case plan
      when 'small'
        3
      when 'medium'
        9
      when 'large'
        100
      end
      
      binding.pry
      
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          price: 'premium-plan',
          quantity: qty,
        }],
        mode: 'subscription',
        success_url:  account_user_stripe_success_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: account_user_stripe_cancel_url
      )
      @subscription = current_user.subscription
      if @subscription.present? && @subscription.update(plan: plan)
        # plan updated successfully
        current_user.setup_stripe_subscription(session)
      else
        # plan was not updated
      end
    
      # render "account/users/confirm_subscription"
    end
  
    def subscribe_to_plan
      plan = params[:plan]
  
      @subscription = current_account.subscription
      if @subscription.present? && @subscription.update(plan: plan)
        # plan updated successfully
        current_account.setup_stripe_subscription
      else
        # plan was not updated
      end
    end
  
  end
  