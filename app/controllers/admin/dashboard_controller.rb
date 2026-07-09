class Admin::DashboardController < Admin::BaseController
  def index
    @products_count  = Product.count
    @orders_count    = Order.count
    @pending_count   = Order.where(status: "pending").count
    @revenue         = Order.where(status: %w[confirmed shipped delivered]).sum(:total)
    @recent_orders   = Order.recent.limit(5)
  end
end
