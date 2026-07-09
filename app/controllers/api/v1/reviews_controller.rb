class Api::V1::ReviewsController < Api::V1::BaseController
  before_action :authenticate_request!, only: [:create, :my_reviews]

  def index
    reviews = Review.where(published: true)
                    .includes(:user, :order)
                    .order(created_at: :desc)
                    .limit(20)
    render json: { reviews: reviews.map { |r| review_json(r) } }
  end

  def create
    order = Order.find_by(id: params[:review][:order_id], user_id: current_user.id)
    return render json: { error: 'Order not found' }, status: :not_found unless order

    review = Review.new(review_params.merge(user_id: current_user.id))
    if review.save
      render json: { review: review_json(review) }, status: :created
    else
      render json: { error: review.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def my_reviews
    reviews = Review.where(user_id: current_user.id).includes(:order)
    render json: { reviews: reviews.map { |r| { order_id: r.order_id, rating: r.rating, comment: r.comment } } }
  end

  private

  def review_params
    params.require(:review).permit(:order_id, :rating, :comment)
  end

  def review_json(r)
    {
      id:         r.id,
      rating:     r.rating,
      comment:    r.comment,
      first_name: r.user.first_name,
      created_at: r.created_at
    }
  end
end
