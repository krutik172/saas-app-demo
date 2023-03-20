class AddCompanyToProjectTeam < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :company, foreign_key: true
    add_reference :teams, :company, foreign_key: true
    add_reference :memberships, :company, foreign_key: true
  end
end
