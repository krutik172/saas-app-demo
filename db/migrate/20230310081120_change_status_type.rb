class ChangeStatusType < ActiveRecord::Migration[7.0]
  def change
    change_column :tickets, :status, :integer, using: 'status::integer'
  end
end
