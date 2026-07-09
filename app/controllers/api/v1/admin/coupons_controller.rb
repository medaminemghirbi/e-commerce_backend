class Api::V1::Admin::CouponsController < Api::V1::Admin::BaseController
  before_action :set_coupon, only: [:show, :update, :destroy]

  def index
    coupons = Coupon.order(created_at: :desc)
    render json: { coupons: coupons.map { |c| coupon_json(c) } }
  end

  def show
    render json: { coupon: coupon_json(@coupon) }
  end

  def create
    coupon = Coupon.new(coupon_params)
    if coupon.save
      render json: { coupon: coupon_json(coupon) }, status: :created
    else
      render json: { error: coupon.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @coupon.update(coupon_params)
      render json: { coupon: coupon_json(@coupon) }
    else
      render json: { error: @coupon.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @coupon.destroy
    render json: { success: true }
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end

  def coupon_params
    permitted = params.require(:coupon).permit(
      :code, :discount_type, :discount_value,
      :min_order_amount, :max_uses, :active, :is_active, :expires_at
    )
    permitted[:active] = permitted.delete(:is_active) if permitted.key?(:is_active)
    permitted
  end

  def coupon_json(c)
    {
      id:                c.id,
      code:              c.code,
      discount_type:     c.discount_type,
      discount_value:    c.discount_value.to_f,
      min_order_amount:  c.min_order_amount.to_f,
      max_uses:          c.max_uses,
      used_count:        c.used_count,
      active:            c.active,
      expires_at:        c.expires_at,
      created_at:        c.created_at
    }
  end
end
