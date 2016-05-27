class Restaurant < ActiveRecord::Base

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

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

  def average_rating
    return 'N/A' if reviews.none?
    reviews.inject(0) {|memo, review| memo + review.rating.to_f} / self.reviews.length
    #reviews.average(:rating) doesn't work, i believe that this useful rails/active record method is only supposed to be used directly on a model with column as the argument, not on the column for a set of associated relations
  end

end
