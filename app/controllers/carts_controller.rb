class CartsController < ApplicationController
  def show
  end

  def add
    product = Product.find(params[:product_id])
    cart    = session[:cart] ||= []
    item    = cart.find { |i| i["product_id"] == product.id.to_s }

    if item
      item["quantity"] += 1
    else
      cart << {
        "product_id" => product.id.to_s,
        "name_fr"    => product.name_fr,
        "name_en"    => product.name_en,
        "name_ar"    => product.name_ar,
        "image"      => product.primary_image,
        "unit_price" => product.current_price.to_f,
        "quantity"   => 1
      }
    end

    session[:cart] = cart
    redirect_back fallback_location: cart_path, notice: "Produit ajouté au panier"
  end

  def remove
    session[:cart]&.reject! { |i| i["product_id"] == params[:product_id] }
    redirect_to cart_path
  end

  def update_qty
    item = session[:cart]&.find { |i| i["product_id"] == params[:product_id] }
    if item
      qty = params[:qty].to_i
      qty <= 0 ? session[:cart].delete(item) : item["quantity"] = qty
    end
    redirect_to cart_path
  end

  def clear
    session.delete(:cart)
    redirect_to cart_path
  end
end
