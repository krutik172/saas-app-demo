class Company < ApplicationRecord
    has_many :memberships
    has_many :users, through: :memberships
    has_many :projects
    has_many :teams
    validates :name, presence: true
    validates_uniqueness_of :name
end
