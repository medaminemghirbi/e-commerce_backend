class Api::V1::Admin::ReviewsController < Api::V1::Admin::BaseController
  before_action :set_review, only: [:update, :destroy]

  def index
    reviews = Review.includes(:user, :order).order(created_at: :desc)
    render json: { reviews: reviews.map { |r| review_json(r) } }
  end

  def update
    @review.update(published: params[:published])
    render json: { review: review_json(@review) }
  end

  def destroy
    @review.destroy
    render json: { success: true }
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_json(r)
    {
      id:         r.id,
      rating:     r.rating,
      comment:    r.comment,
      published:  r.published,
      user_email: r.user.email,
      first_name: r.user.first_name,
      order_id:   r.order_id,
      created_at: r.created_at
    }
  end
end
