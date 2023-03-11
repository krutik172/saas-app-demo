class AddDescriptionToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :description, :text
    add_column :projects, :expected_completion_date, :date
  end
end
