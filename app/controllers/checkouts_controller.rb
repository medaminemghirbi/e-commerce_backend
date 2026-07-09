class CheckoutsController < ApplicationController
  DELIVERY_FEE = 8.0

  def show
    redirect_to cart_path, alert: "Votre panier est vide." if cart_items.empty?
  end

  def create
    if cart_items.empty?
      redirect_to cart_path, alert: "Votre panier est vide." and return
    end

    subtotal = cart_total.round(2)
    delivery = subtotal >= 100 ? 0 : DELIVERY_FEE

    @order = Order.new(
      user:             current_user,
      user_email:       current_user&.email || params[:order][:user_email],
      items:            cart_items,
      subtotal:         subtotal,
      delivery_fee:     delivery,
      total:            (subtotal + delivery).round(2),
      status:           "pending",
      payment_method:   "cod",
      delivery_address: address_params,
      notes:            params[:order][:notes]
    )

    if @order.save
      session.delete(:cart)
      session[:last_order_id] = @order.id
      redirect_to checkout_success_path
    else
      render :show, status: :unprocessable_entity
    end
  end

  def success
    @order = Order.find_by(id: session[:last_order_id])
    redirect_to root_path unless @order
  end

  private

  def address_params
    params.require(:order).require(:delivery_address).permit(
      :full_name, :phone, :address, :city, :wilaya, :email
    ).to_h
  end
end
