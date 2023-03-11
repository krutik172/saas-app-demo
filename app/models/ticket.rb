class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_one :team, through: :project
  has_rich_text :description
  validates :description, presence: true
  
  before_create do
    self.status ||= 'open'
  end
  enum status: %i[open building testing reopen resolved closed]
  
end
