class Restaurant < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  belongs_to :user
  validates :name, length: { minimum: 3 }, uniqueness: true
  # validates_associated :reviews
end