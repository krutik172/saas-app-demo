class StripeChargeService
    DEFAULT_CURRENCY = 'usd'.freeze
    
    def initialize(params, user, product, view_context)
      @stripe_token = params[:stripe_token]
      @stripe_email = params[:stripe_email]
      @product = product
      @amount = params[:price]
      @user = user
      @view_context = view_context
    end
  
    def call
      create_charge(find_customer)
    end
  
    private
  
    attr_accessor :user, :amount, :stripe_token, :product, :view_context
  
    def find_customer
      if user.stripe_token
        retrieve_customer(user.stripe_token)
      else
        create_customer
      end
    end
  
    def retrieve_customer(stripe_token)
      Stripe::Customer.retrieve(stripe_token) 
    end
  
    def create_customer
      customer = Stripe::Customer.create(
        source: stripe_token
      )
      user.update(stripe_token: customer.id)
      customer
    end
  
    def create_charge(customer)
      if customer.default_source.nil?
        session = Stripe::Checkout::Session.create(
          customer: customer,
          payment_method_types: ['card'],
          line_items: [{
              name: product.product_name,
              amount: product.price.to_i,
              currency: 'usd',
              quantity: 1
          }],
          mode: 'payment',
          success_url: view_context.product_url(product),
          cancel_url:  view_context.product_url(product)
          )
      else
        Stripe::Charge.create(
          customer: customer.id,
          amount: order_amount,
          description: customer.email,
          currency: DEFAULT_CURRENCY
        )
      end
      session
    end
  
    def order_amount
      Product.find_by(id: product).price
    end
  end