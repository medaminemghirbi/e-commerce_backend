class Api::V1::Admin::OrdersController < Api::V1::Admin::BaseController
  before_action :set_order, only: [:show, :update_status, :destroy]

  def index
    scope = Order.order(created_at: :desc)
    scope = scope.where(status: params[:status]) if params[:status].present?
    orders = scope.page(params[:page]).per(20)
    render json: { orders: orders.map { |o| order_json(o) }, meta: pagination_meta(orders) }
  end

  def show
    render json: { order: order_json(@order) }
  end

  def update_status
    @order.update!(status: params[:status])
    render json: { order: order_json(@order) }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    @order.destroy
    render json: { success: true }
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_json(o)
    {
      id: o.id, user_email: o.user_email, items: o.items,
      subtotal: o.subtotal.to_f, delivery_fee: o.delivery_fee.to_f, total: o.total.to_f,
      coupon_code: o.coupon_code, discount_amount: o.discount_amount.to_f,
      status: o.status, delivery_address: o.delivery_address, notes: o.notes,
      created_at: o.created_at
    }
  end
end
