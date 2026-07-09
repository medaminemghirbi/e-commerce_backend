class Api::V1::CouponsController < Api::V1::BaseController
  def validate
    coupon = Coupon.find_by(code: params[:code]&.upcase&.strip)
    order_total = (params[:order_total] || params[:order_amount]).to_f

    if coupon.nil?
      return render json: { valid: false, message: 'Code promo invalide' }
    end

    unless coupon.valid_for?(order_total)
      message = if !coupon.active?
        'Ce code promo est désactivé'
      elsif coupon.expires_at.present? && coupon.expires_at < Time.current
        'Ce code promo a expiré'
      elsif coupon.max_uses.present? && coupon.used_count >= coupon.max_uses
        "Ce code promo a atteint sa limite d'utilisation"
      else
        "Commande minimum requise : #{coupon.min_order_amount} TND"
      end
      return render json: { valid: false, message: message }
    end

    discount = coupon.apply(order_total)
    render json: {
      valid:           true,
      code:            coupon.code,
      discount_type:   coupon.discount_type,
      discount_value:  coupon.discount_value.to_f,
      discount_amount: discount,
      new_total:       (order_total - discount).round(2)
    }
  end
end
