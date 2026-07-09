class Admin::SettingsController < Admin::BaseController
  def show
    pricing = Setting.get("pricing") || { "margin" => 20, "promotion" => 20 }
    @margin    = pricing["margin"].to_i
    @promotion = pricing["promotion"].to_i
  end

  def update
    margin    = params[:margin].to_i
    promotion = params[:promotion].to_i
    Setting.set("pricing", { "margin" => margin, "promotion" => promotion })
    Product.find_each do |p|
      p.update_columns(
        selling_price:      (p.purchase_price * (1 + margin / 100.0)).round(2),
        promotion_discount: promotion
      )
    end
    redirect_to admin_settings_path, notice: "Paramètres enregistrés."
  end
end
