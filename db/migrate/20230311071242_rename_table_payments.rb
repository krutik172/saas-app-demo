class RenameTablePayments < ActiveRecord::Migration[7.0]
  def change
    rename_table :payments, :subscriptions
    add_column :subscriptions, :plan, :string
    add_column :subscriptions, :stripe_subscription_id, :string
    add_column :subscriptions, :stripe_customer_id, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
