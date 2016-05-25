class Restaurant < ActiveRecord::Base

  has_many :reviews, -> { extending WithUserAssociationExtension }, dependent: :destroy
  belongs_to :user

  validates :name, length: { minimum: 3 }, uniqueness: true

  # def build_review(review_params, current_user)
  #   review = self.reviews.build(review_params)
  #   review.user = current_user
  #   review
  # end

  def owned_by?(current_user)
    current_user.restaurants.include?(self)
  end

end
