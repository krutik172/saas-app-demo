class User < ApplicationRecord
  include Users::Base
  include Roles::User
  has_one :subscription
  has_many :tickets, dependent: :destroy

  after_create :setup_subscription
  private

  def setup_subscription
    Subscription.create(user_id: self.id, plan: "free")
  end
end
