class Project < ApplicationRecord
  # 🚅 add concerns above.
  # 🚅 add attribute accessors above.
  belongs_to :team
  belongs_to :company, optional: true
  # 🚅 add belongs_to associations above.

  has_many :goals, dependent: :destroy
  has_many :tickets, dependent: :destroy
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  validates :description, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
