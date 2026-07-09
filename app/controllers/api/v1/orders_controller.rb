class Api::V1::OrdersController < Api::V1::BaseController
  before_action :authenticate_request!, only: [:index]

  def index
    orders = current_user.orders.order(created_at: :desc)
    render json: { orders: orders.map { |o| order_json(o) } }
  end

  def create
    user = nil
    header = request.headers['Authorization']
    if header.present?
      begin
        decoded = JsonWebToken.decode(header.split(' ').last)
        user = User.find_by(id: decoded[:user_id])
      rescue; end
    end

    p = params.require(:order).permit(
      :user_email, :subtotal, :delivery_fee, :total, :notes, :coupon_code,
      delivery_address: [:full_name, :phone, :address, :city, :wilaya, :email],
      items: [:productId, :name_fr, :image, :unit_price, :quantity, :subtotal]
    )

    coupon = nil
    discount_amount = 0.0

    if p[:coupon_code].present?
      coupon = Coupon.find_by(code: p[:coupon_code].upcase.strip)
      if coupon&.valid_for?(p[:subtotal].to_f)
        discount_amount = coupon.apply(p[:subtotal].to_f)
      end
    end

    order = Order.new(
      user:             user,
      user_email:       p[:user_email],
      items:            p[:items]&.map(&:to_h),
      subtotal:         p[:subtotal],
      delivery_fee:     p[:delivery_fee],
      total:            p[:total],
      coupon_code:      coupon&.code,
      discount_amount:  discount_amount,
      status:           'pending',
      payment_method:   'cod',
      delivery_address: p[:delivery_address]&.to_h,
      notes:            p[:notes]
    )

    if order.save
      coupon&.increment_usage!
      render json: { order: order_json(order) }, status: :created
    else
      render json: { error: order.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def order_json(o)
    {
      id:               o.id,
      user_email:       o.user_email,
      items:            o.items,
      subtotal:         o.subtotal.to_f,
      delivery_fee:     o.delivery_fee.to_f,
      total:            o.total.to_f,
      coupon_code:      o.coupon_code,
      discount_amount:  o.discount_amount.to_f,
      status:           o.status,
      delivery_address: o.delivery_address,
      notes:            o.notes,
      created_at:       o.created_at
    }
  end
end
