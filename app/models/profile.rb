class Profile < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy
  has_one_attached :photo

  validates :village, presence: true
  validates :phone_number, presence: true
  validates :birthday, presence: true
  validates :join_date, presence: true
  validates :business_type, presence: true
  validates :photo, presence: true

  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :village, :business_type ],
    associated_against: {
      user: [ :first_name, :last_name, :email ]
    },
    using: {
      tsearch: { prefix: true }
    }
end
