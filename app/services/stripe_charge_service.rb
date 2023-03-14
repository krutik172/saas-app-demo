class StripeChargeService
    DEFAULT_CURRENCY = 'usd'.freeze
    
    def initialize(user, subscription, view_context)
      @user = user
      @subscription = subscription
      @view_context = view_context
    end
  
    def call
      create_charge(find_customer)
    end
  
    private
  
    attr_accessor :name, :description, :email, :subscription, :view_context
  
    def find_customer
      if subscription.stripe_customer_id.present?
        # load stripe subscription and update customer plan
        retrieve_customer(subscription.stripe_customer_id)
      else
        # if no stripe customer id is found on subscription, then create new stripe subscription
        create_customer
      end
    end
  
    def retrieve_customer(stripe_customer_id)
      account = Stripe::Customer.retrieve(stripe_customer_id)
    end
  
    def create_customer
      customer = Stripe::Customer.create(
        name: @user.full_name,
        email: @user.email,
        description: "Customer id: #{@user.id}",
      )
      subscription.update(stripe_customer_id: customer.id)
      customer
    end
  
    def create_charge(customer)
      payment_method = Stripe::PaymentMethod.create({
        type: "card",
        card: {
          number: "4242424242424242",
          exp_month: 12,
          exp_year: 2024,
          cvc: "123",
        },
      })
      payment_method.attach(customer: customer.id)
      customer.invoice_settings.default_payment_method = payment_method.id
      customer.save
      subs = Stripe::Subscription.create({
        customer: customer.id,
        items: [
          {
            price: "price_1Ml7wVSA7mfSJAFlCUspJjPD",
          },
        ],
      })
      session = Stripe::Checkout::Session.create(
        customer: customer,
        payment_method_types: ['card'],
        line_items: [{
          price: 'price_1Ml7wVSA7mfSJAFlCUspJjPD',
          quantity: 1,
        }],
        mode: 'subscription',
        success_url:  view_context.account_teams_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: view_context.account_teams_url
      )
      subscription.update(plan: "premium", stripe_subscription_id: subs.id)
      session
    end
  end