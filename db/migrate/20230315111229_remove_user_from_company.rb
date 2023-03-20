class RemoveUserFromCompany < ActiveRecord::Migration[7.0]
  def change
    remove_column :companies, :user_id
  end
end
