class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update_status, :destroy]

  def index
    @orders = Order.recent.page(params[:page]).per(20)
    @orders = @orders.where(status: params[:status]) if params[:status].present?
  end

  def show; end

  def update_status
    @order.update(status: params[:status])
    redirect_to admin_orders_path, notice: "Statut mis à jour."
  end

  def destroy
    @order.destroy
    redirect_to admin_orders_path, notice: "Commande supprimée."
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
